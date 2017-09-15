module Kite
  class Core < Base

    include Kite::Helpers

    desc "new CLOUD_PATH", "Generate Cloud infrastructure skeleton from configuration"
    # Creates a cloud infrastructure skeleton with a given name
    def new(cloud_name)
      target = Kite::Cloud.new(self, cloud_name)
      target.prepare
    end

    method_option :cloud, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc "generate", "Generate Cloud IaC from configuration"
    # Generates Infrastructure as Code and setup scripts for the given cloud using values from <b>config/cloud.yml</b>
    def generate()
      say "Generating Cloud #{ options[:cloud] } IaC", :green
      @values = parse_cloud_config

      case options[:cloud]
      when 'aws'
        copy_file('aws/terraform/main.tf',                 'terraform/main.tf')
        copy_file('aws/terraform/network.tf',              'terraform/network.tf')
        copy_file('aws/terraform/outputs.tf',              'terraform/outputs.tf')
        copy_file('aws/terraform/variables.tf',            'terraform/variables.tf')
        template('aws/terraform/terraform.tfvars.erb',     'terraform/terraform.tfvars')
        copy_file('aws/README.md',                         'README.md')

        template('aws/bosh-install.sh.erb',                 'bin/bosh-install.sh')
        template('aws/setup-tunnel.sh.erb',                 'bin/setup-tunnel.sh')
        template('aws/set-env.sh.erb',                      'bin/set-env.sh')
        chmod('bin/bosh-install.sh', 0755)
        chmod('bin/setup-tunnel.sh', 0755)

      when 'gcp'
        copy_file('gcp/terraform/main.tf',                  'terraform/main.tf')
        copy_file('gcp/terraform/network.tf',               'terraform/network.tf')
        copy_file('gcp/terraform/outputs.tf',               'terraform/outputs.tf')
        copy_file('gcp/terraform/variables.tf',             'terraform/variables.tf')
        template('gcp/terraform/terraform.tfvars.erb',      'terraform/terraform.tfvars')
        copy_file('gcp/README.md',                          'README.md', force: true)

        template('gcp/bosh-install.sh.erb',                 'bin/bosh-install.sh')
        template('gcp/bosh-vars.yml.erb',                   'bosh-vars.yml')
        template('gcp/setup-tunnel.sh.erb',                 'bin/setup-tunnel.sh')
        chmod('bin/bosh-install.sh', 0755)
        chmod('bin/setup-tunnel.sh', 0755)

      else
        say 'Cloud provider not specified'

      end
    end

    desc 'render MANIFEST', 'Render manifest file from configuration and Terraform output'
    subcommand "render", Kite::Render

    desc "version", "Return kite version"
    # Return kite version
    def version
      say "v#{ Kite::VERSION }"
    end
  end
end
