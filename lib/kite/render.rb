module Kite
  # Subcommand for rendering manifests, deployments etc.
  class Render < Base

    include Kite::Helpers

    no_commands do
      def ingress_db_file
        "config/ingress.yml"
      end

      def ingress_db
        @db ||= YAML.load(File.read(ingress_db_file)) rescue {}
      end

      def ingress_db_save!
        create_file ingress_db_file, YAML.dump(ingress_db), force: true
      end

      def ingress_add_entry(hostname, upstreams, args = {})
        raise "upstreams argument should be an array" unless upstreams.is_a?(Array)
        args[:port] ||= 80
        args[:protocol] ||= "http"
        ingress_db[hostname] = {
          upstreams: upstreams,
          port: args[:port],
          protocol: args[:protocol],
        }
        ingress_db_save!
      end
    end

    desc "manifest <type>", "Renders a manifest of selected type"
    long_desc <<-LONGDESC
      Available types:
      \x5  BOSH        Render Bosh environement
      \x5  CONCOURSE   Render Concourse deployment
      \x5  VAULT       Render Vault deployment
      \x5  INGRESS     Render Ingress deployment
      \x5  PROMETHEUS  Render Prometheus deployment
      \x5  OAUTH       Render OAuth (UAA) deployment
    LONGDESC
    method_option :cloud, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    # Render a manifest of selected type based on <b>config/cloud.yml</b> and <b>terraform apply</b> results
    def manifest(type)
      type = type.downcase
      say "Rendering #{type} manifest", :green
      @values = parse_cloud_config
      @tf_output = parse_tf_state('terraform/terraform.tfstate') if options[:cloud] == 'aws'

      if options[:cloud] == 'aws'
        @private_subnet = IPAddr.new(@values['aws']['private_subnet']['network']).to_range.to_a
        @public_subnet = IPAddr.new(@values['aws']['public_subnet']['network']).to_range.to_a
      else
        @private_subnet = IPAddr.new(@values['gcp']['subnet_cidr']).to_range.to_a
      end

      @static_ip_vault            = @private_subnet[11].to_s
      @static_ips_concourse       = [@private_subnet[12]].map(&:to_s)
      @static_ip_prometheus_stack = @private_subnet[18].to_s
      @static_ip_oauth            = @private_subnet[23].to_s

      case type
      when "bosh"
        directory("#{options[:cloud]}/deployments/bosh",                          'deployments/bosh')
        template("#{options[:cloud]}/bosh-vars.yml.erb",                          'config/bosh-vars.yml')
        copy_file("#{options[:cloud]}/docs/bosh.md",                              "docs/bosh.md")
        template("#{options[:cloud]}/bin/bosh-install.sh.tt",                     "bin/bosh-install.sh")
        chmod('bin/bosh-install.sh', 0755)

      when "concourse"
        directory("#{options[:cloud]}/deployments/concourse",                     "deployments/concourse")
        copy_file("#{options[:cloud]}/docs/concourse.md",                         "docs/concourse.md")
        template("#{options[:cloud]}/bin/concourse-deploy.sh.tt",                 "bin/concourse-deploy.sh")
        chmod('bin/concourse-deploy.sh', 0755)
        ingress_add_entry(@values['concourse']['hostname'], @static_ips_concourse, port: 8080)

      when "vault"
        template("#{options[:cloud]}/deployments/vault/vault.yml.erb",            "deployments/vault/vault.yml")
        copy_file("#{options[:cloud]}/docs/vault.md",                             "docs/vault.md")
        template("#{options[:cloud]}/bin/vault-deploy.sh.tt",                     "bin/vault-deploy.sh")
        chmod('bin/vault-deploy.sh', 0755)
        ingress_add_entry(@values['vault']['hostname'], [@static_ip_vault], port: 8200)

      when "ingress"
        template("#{options[:cloud]}/deployments/ingress/ingress.yml.erb",        "deployments/ingress/ingress.yml")
        copy_file("#{options[:cloud]}/docs/ingress.md",                           "docs/ingress.md")
        template("#{options[:cloud]}/bin/ingress-deploy.sh.tt",                   "bin/ingress-deploy.sh")
        template("#{options[:cloud]}/bin/ingress-update.sh.tt",                   "bin/ingress-update.sh")
        chmod('bin/ingress-deploy.sh', 0755)
        chmod('bin/ingress-update.sh', 0755)

      when "prometheus"
        directory("#{options[:cloud]}/deployments/prometheus",                    "deployments/prometheus")
        copy_file("#{options[:cloud]}/docs/prometheus.md",                        "docs/prometheus.md")
        template("#{options[:cloud]}/bin/prometheus-deploy.sh.tt",                "bin/prometheus-deploy.sh")
        chmod('bin/prometheus-deploy.sh', 0755)
        ingress_add_entry(@values['alertmanager']['hostname'], [@static_ip_prometheus_stack], port: 9093)
        ingress_add_entry(@values['grafana']['hostname'], [@static_ip_prometheus_stack], port: 3000)
        ingress_add_entry(@values['prometheus']['hostname'], [@static_ip_prometheus_stack], port: 9090)

      when "oauth"
        directory("#{options[:cloud]}/deployments/oauth",                         "deployments/oauth")
        copy_file("#{options[:cloud]}/config/oauth.yml",                          "config/oauth.yml")
        template("#{options[:cloud]}/docs/oauth.md",                              "docs/oauth.md")
        template("#{options[:cloud]}/bin/oauth-deploy.sh.tt",                     "bin/oauth-deploy.sh")
        chmod('bin/oauth-deploy.sh', 0755)
        ingress_add_entry(@values['oauth']['hostname'], [@static_ip_oauth], port: 8080)

      else
        say "Manifest type not specified"

      end
    end
  end
end
