module Kite
  # Subcommand for rendering manifests, deployments etc.
  class Render < Base

    include Kite::Helpers

    desc "manifest <type>", "Renders a manifest of selected type"
    method_option :cloud, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    # Render a manifest of selected type based on <b>config/cloud.yml</b> and <b>terraform apply</b> results
    def manifest(type)
      say "Rendering #{type} manifest", :green
      @values = parse_cloud_config
      @tf_output = parse_tf_state('terraform/terraform.tfstate') if options[:cloud] == 'aws'

      if options[:cloud] == 'aws'
        @private_subnet = IPAddr.new(@values['aws']['private_subnet']['network']).to_range.to_a
      else
        @private_subnet = IPAddr.new(@values['gcp']['subnet_cidr']).to_range.to_a
      end

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

      when "vault"
        template("#{options[:cloud]}/deployments/vault/vault.yml.erb",            "deployments/vault/vault.yml")
        copy_file("#{options[:cloud]}/docs/vault.md",                             "docs/vault.md")
        template("#{options[:cloud]}/bin/vault-deploy.sh.tt",                     "bin/vault-deploy.sh")
        chmod('bin/vault-deploy.sh', 0755)

      when "nginx"
        template("#{options[:cloud]}/deployments/nginx/nginx.yml.erb",            "deployments/nginx/nginx.yml")

      else
        say "Manifest type not specified"

      end
    end
  end
end
