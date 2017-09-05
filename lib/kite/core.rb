module Kite
  class Core < Base

    include Kite::Helpers

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), "../../tpl"))
    end

    desc "new CLOUD_PATH", "Generate Cloud infrastructure skeleton from configuration"
    def new(cloud_name)
      target = Kite::Cloud.new(self, cloud_name)
      target.prepare
    end

    method_option :cloud, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc "generate", "Generate Cloud IaC from configuration"
    def generate()
      say "Generating Cloud #{ options[:cloud] } IaC", :green
      @values = YAML.load(File.read('config/cloud.yml'))
      return false unless check_cloud_config(@values)

      case options[:cloud]
      when 'aws'
        copy_file('aws/terraform/main.tf',                  'terraform/main.tf')
        copy_file('aws/terraform/network.tf',               'terraform/network.tf')
        copy_file('aws/terraform/outputs.tf',               'terraform/outputs.tf')
        copy_file('aws/terraform/variables.tf',             'terraform/variables.tf')
        template('aws/terraform/terraform.tfvars.erb',      'terraform/terraform.tfvars')

        copy_file('aws/README.md',                          'README.md')
        template('aws/bootstrap.sh.erb',                    'bootstrap.sh')
        chmod('bootstrap.sh', 0755)

      when 'gcp'
        copy_file('gcp/terraform/main.tf',                  'terraform/main.tf')
        copy_file('gcp/terraform/network.tf',               'terraform/network.tf')
        copy_file('gcp/terraform/outputs.tf',               'terraform/outputs.tf')
        copy_file('gcp/terraform/variables.tf',             'terraform/variables.tf')
        template('gcp/terraform/terraform.tfvars.erb',      'terraform/terraform.tfvars')
        template('gcp/bosh-install.sh.erb',                 'bin/bosh-install.sh')
        chmod('bin/bosh-install.sh', 0755)

      else
        say 'Cloud provider not specified'

      end
    end

    desc 'render MANIFEST', 'Render manifest file from configuration and Terraform output'
    def render(manifest)
      return false unless check_terraform_applied

      say "Rendering #{ manifest } manifest", :green
      @values = YAML.load(File.read('config/cloud.yml'))
      @tf_output = parse_tf_state('terraform/terraform.tfstate')

      case manifest
      when "bosh"
        copy_file("aws/bosh/jumpbox-user.yml",        "jumpbox-user.yml")
        copy_file("aws/bosh/cpi.yml",                 "cpi.yml")
        copy_file("aws/bosh/bosh_director.yml",       "bosh_director.yml")
        template("aws/bosh/bosh_vars.yml.erb",        "bosh_vars.yml")

      when "concourse"
        template("aws/concourse/aws_cloud.yml.erb",   "aws_cloud.yml")
        template("aws/concourse/concourse.yml.erb",   "concourse.yml")

      else
        say "Manifest type not specified"

      end
    end

    desc "version", "Return kite version"
    def version
      say "v#{ Kite::VERSION }"
    end
  end
end
