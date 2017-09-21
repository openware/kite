module Kite
  # Subcommand for rendering manifests, deployments etc.
  class Render < Base

    include Kite::Helpers

    desc "manifest <type>", "Renders a manifest of selected type"
    method_option :cloud, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    # Render a manifest of selected type based on <b>config/cloud.yml</b> and <b>terraform apply</b> results
    def manifest(type)
      say "Rendering #{type} manifest", :green
      @values = cloud.cloud_conf
      @tf_output = cloud.tf_output

      case type
      when "bosh"
        directory("#{options[:cloud]}/deployments",                    'deployments')

      when "concourse"
        @private_subnet = cloud.private_subnet if options[:cloud] == 'aws'

        template("#{options[:cloud]}/deployments/concourse/cloud-config.yml.erb", "deployments/concourse/cloud-config.yml")
        template("#{options[:cloud]}/deployments/concourse/concourse.yml.erb", "deployments/concourse/concourse.yml")

      else
        say "Manifest type not specified"

      end
    end
  end
end
