require 'spec_helper'

describe(Kite::Render) do
  include TmpDirIsolation

  def new_stack
    Kite::Core.start(["new", "test"], debug: true)
    Dir.chdir "test"
  end

  def generate_aws
    Kite::Generate.start(["cloud", "--provider", "aws"], debug: true)

    # Terraform tfstate fixture for AWS
    # Will be removed after tfstate migration to S3
    tfstate_fixture = %q(
    {
      "modules": [
        {
          "outputs": {
            "security_group_id": {
              "sensitive": false,
              "type": "string",
              "value": "sg-test"
            },
            "platform_subnet_id": {
              "sensitive": false,
              "type": "string",
              "value": "subnet-test"
            }
          }
        }
      ]
    }
    )

    # Create terraform.tfstate file for AWS
    File.open('terraform/terraform.tfstate', 'w') { |file| file.write(tfstate_fixture) }
  end

  def assert_bosh_files
    expect(Dir).to exist('deployments/bosh')

    expect(File).to exist('deployments/bosh/bosh.yml')
    expect(File).to exist('deployments/bosh/cloud-config.yml')
    expect(File).to exist('deployments/bosh/cpi.yml')
    expect(File).to exist('deployments/bosh/jumpbox-user.yml')

    expect(File).to exist('docs/bosh.md')
    expect(File).to exist('config/bosh-vars.yml')
    expect(File).to exist('bin/bosh-install.sh')
  end

  def assert_concourse_files
    expect(Dir).to exist('deployments/concourse')

    expect(File).to exist('deployments/concourse/concourse.yml')
    expect(File).to exist('docs/concourse.md')
    expect(File).to exist('bin/concourse-deploy.sh')
  end

  def assert_vault_files
    expect(Dir).to exist('deployments/vault')

    expect(File).to exist('deployments/vault/vault.yml')
    expect(File).to exist('docs/vault.md')
    expect(File).to exist('bin/vault-deploy.sh')
  end

  def assert_prometheus_files
    expect(Dir).to exist('deployments/prometheus')

    expect(File).to exist('deployments/prometheus/prometheus.yml')
    expect(File).to exist('deployments/prometheus/monitor-kubernetes.yml')
    expect(File).to exist('deployments/prometheus/monitor-bosh.yml')
    expect(File).to exist('docs/prometheus.md')
    expect(File).to exist('bin/prometheus-deploy.sh')
  end

  context "Cloud AWS provider" do
    it "renders a Bosh manifest and related files" do
      new_stack
      generate_aws

      Kite::Render.start(["manifest", "bosh", "--cloud", "aws"], debug: true)
      assert_bosh_files
    end

    it "renders a Concourse manifest" do
      new_stack
      generate_aws

      Kite::Render.start(["manifest", "concourse", "--cloud", "aws"], debug: true)
      assert_concourse_files
    end

    it "renders a Vault manifest" do
      new_stack
      generate_aws

      Kite::Render.start(["manifest", "vault", "--cloud", "aws"], debug: true)
      assert_vault_files
    end

    it "renders a Prometheus manifest" do
      new_stack
      generate_aws

      Kite::Render.start(["manifest", "prometheus", "--cloud", "aws"], debug: true)
      assert_prometheus_files
    end
  end

  context "Cloud GCP provider" do
    it "renders a Bosh manifest and related files" do
      new_stack

      Kite::Render.start(["manifest", "bosh", "--cloud", "gcp"], debug: true)
      assert_bosh_files
    end

    it "renders a Concourse manifest" do
      new_stack

      Kite::Render.start(["manifest", "concourse", "--cloud", "gcp"], debug: true)
      assert_concourse_files
    end

    it "renders a Vault manifest" do
      new_stack

      Kite::Render.start(["manifest", "vault", "--cloud", "gcp"], debug: true)
      assert_vault_files
    end
  end
end
