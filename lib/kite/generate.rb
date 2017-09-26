module Kite
  # Subcommand for rendering manifests, deployments etc.
  class Generate < Base
    include Kite::Helpers

    method_option :provider, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc "cloud", "Generate cloud IaC from configuration"
    # Generates Infrastructure as Code and setup scripts for the given cloud using values from <b>config/cloud.yml</b>
    def cloud()
      say "Generating cloud #{ options[:provider] } IaC", :green
      @values = parse_cloud_config

      case options[:provider]
        when 'aws'
          directory('aws/terraform',                          'terraform')
          copy_file('aws/README.md',                          'README.md', force: true)

          template('aws/bosh-install.sh.erb',                 'bin/bosh-install.sh')
          template('aws/setup-tunnel.sh.erb',                 'bin/setup-tunnel.sh')
          template('aws/concourse-deploy.sh.erb',             'bin/concourse-deploy.sh')
          template('aws/set-env.sh.erb',                      'bin/set-env.sh')
          chmod('bin/bosh-install.sh', 0755)
          chmod('bin/concourse-deploy.sh', 0755)
          chmod('bin/setup-tunnel.sh', 0755)

        when 'gcp'
          directory('gcp/terraform',                          'terraform')
          copy_file('gcp/README.md',                          'README.md', force: true)

          template('gcp/bosh-install.sh.erb',                 'bin/bosh-install.sh')
          template('gcp/setup-tunnel.sh.erb',                 'bin/setup-tunnel.sh')
          template('gcp/concourse-deploy.sh.erb',             'bin/concourse-deploy.sh')
          template('gcp/vault-deploy.sh.erb',                 'bin/vault-deploy.sh')
          template('gcp/set-env.sh.erb',                      'bin/set-env.sh')
          chmod('bin/bosh-install.sh', 0755)
          chmod('bin/concourse-deploy.sh', 0755)
          chmod('bin/vault-deploy.sh', 0755)
          chmod('bin/setup-tunnel.sh', 0755)

        else
          say 'Cloud provider not specified'

      end
    end

    method_option :name, type: :string, desc: "Task name", required: true
    desc "task", "Generate task IaC from configuration"
    def task()
      say "Generating task #{ options[:name] } IaC", :green
    end
  end
end
