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

      case options[:cloud]
      when "aws"
        copy_file("aws/terraform/aws-concourse.tf",               "terraform/aws-concourse.tf")
        copy_file("aws/terraform/aws-vault.tf",                   "terraform/aws-vault.tf")
        copy_file("aws/terraform/bosh-aws-base.tf",               "terraform/bosh-aws-base.tf")
        copy_file("aws/terraform/outputs.tf",                     "terraform/outputs.tf")
        copy_file("aws/terraform/variables.tf",                   "terraform/variables.tf")
        template("aws/terraform/terraform.tfvars.erb",            "terraform/terraform.tfvars")

        copy_file("aws/README.md",                                "README.md")
        copy_file("aws/bootstrap.sh",                             "bootstrap.sh")

      when "gcp"
        template("gcp/manifest.yml.erb",            "manifest.yml")
        template("gcp/cloud-config.yml.erb",        "cloud-config.yml")
        copy_file("gcp/concourse.yml.erb",          "concourse.yml")
        copy_file("gcp/README.md",                  "README.md")
        directory("gcp/scripts",                    "scripts")
        copy_file("gcp/INSTALL.md",                 "INSTALL.md")
        template("gcp/env.example.erb",             ".env")
        copy_file("gcp/main.tf",                    "main.tf")
        copy_file("gcp/concourse.tf",               "concourse.tf")
      else
        say "Cloud provider not specified"

      end
    end

    desc "render MANIFEST", "Render manifest file from configuration and Terraform output"
    def render(manifest)
      say "Rendering #{ manifest } manifest", :green
      @values = YAML.load(File.read('config/cloud.yml'))
      @tf_output = parse_tf_state('terraform/terraform.tfstate')

      case manifest
      when "bosh"
        template("aws/bosh/bosh_director.yml.erb",    "bosh_director.yml")

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
