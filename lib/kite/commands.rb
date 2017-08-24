class Kite::Commands < Thor
  include Thor::Actions
  include Kite::Helpers

  def self.source_root
    File.expand_path(File.join(File.dirname(__FILE__), "../.."))
  end

  method_option :values, type: :string, default: "defaults.yml", required: true
  method_option :cloud, type: :string, desc: "Cloud supplier", enum: %w{aws gcp}, required: true
  desc "new CLOUDNAME", "Generate Cloud IaC from configuration"
  def new(cloud_name)
    say "Generating Cloud #{ cloud_name } IaC", :green
    @values = YAML.load(File.read(options[:values]))

    case options[:cloud]
    when "aws"
      copy_file("tpl/aws/bin/make_cloud_config.sh",                 "#{cloud_name}/bin/make_cloud_config.sh")
      copy_file("tpl/aws/bin/make_manifest_bosh-init.sh",           "#{cloud_name}/bin/make_manifest_bosh-init.sh")
      copy_file("tpl/aws/bin/make_manifest_concourse-cluster.sh",   "#{cloud_name}/bin/make_manifest_concourse-cluster.sh")

      copy_file("tpl/aws/terraform/aws-concourse.tf",               "#{cloud_name}/terraform/aws-concourse.tf")
      copy_file("tpl/aws/terraform/aws-vault.tf",                   "#{cloud_name}/terraform/aws-vault.tf")
      copy_file("tpl/aws/terraform/bosh-aws-base.tf",               "#{cloud_name}/terraform/bosh-aws-base.tf")
      copy_file("tpl/aws/terraform/outputs.tf",                     "#{cloud_name}/terraform/outputs.tf")
      template("tpl/aws/terraform/terraform.tfvars.erb",            "#{cloud_name}/terraform/terraform.tfvars")
      copy_file("tpl/aws/terraform/variables.tf",                   "#{cloud_name}/terraform/variables.tf")
      copy_file("tpl/aws/terraform/variables.tf",                   "#{cloud_name}/terraform/variables.tf")

      template("tpl/aws/env.example.erb",                           "#{cloud_name}/.env")
      copy_file("tpl/aws/README.md",                                "#{cloud_name}/README.md")
      copy_file("tpl/aws/bootstrap.sh",                             "#{cloud_name}/bootstrap.sh")

    when "gcp"
      template("tpl/gcp/manifest.yml.erb",            "#{cloud_name}/manifest.yml")
      template("tpl/gcp/cloud-config.yml.erb",        "#{cloud_name}/cloud-config.yml")
      copy_file("tpl/gcp/concourse.yml.erb",          "#{cloud_name}/concourse.yml")
      copy_file("tpl/gcp/README.md",                  "#{cloud_name}/README.md")
      directory("tpl/gcp/scripts",                    "#{cloud_name}/scripts")
      copy_file("tpl/gcp/INSTALL.md",                 "#{cloud_name}/INSTALL.md")
      template("tpl/gcp/env.example.erb",             "#{cloud_name}/.env")
      copy_file("tpl/gcp/main.tf",                    "#{cloud_name}/main.tf")
      copy_file("tpl/gcp/concourse.tf",               "#{cloud_name}/concourse.tf")
    end
  end
end
