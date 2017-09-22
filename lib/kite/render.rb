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
      @tf_output = parse_tf_state('terraform/terraform.tfstate')

      case type
      when "bosh"
        if options[:cloud] == 'aws'
          @private_subnet = IPAddr.new(@values['aws']['private_subnet']['network']).to_range.to_a
        else
          @private_subnet = IPAddr.new(@values['gcp']['subnet_cidr']).to_range.to_a
        end

        directory("#{options[:cloud]}/deployments/bosh",                          'deployments/bosh')

      when "concourse"
        template("#{options[:cloud]}/deployments/concourse/cloud-config.yml.erb", "deployments/concourse/cloud-config.yml")
        template("#{options[:cloud]}/deployments/concourse/concourse.yml.erb",    "deployments/concourse/concourse.yml")
      when "vault"
        copy_file("#{options[:cloud]}/deployments/vault/vault.yml",               "deployments/vault/vault.yml")
        copy_file("#{options[:cloud]}/vault.md",                                  "docs/vault.md")

      else
        say "Manifest type not specified"

      end
    end
  end
end
