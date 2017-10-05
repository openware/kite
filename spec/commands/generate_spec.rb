require "spec_helper"

describe(Kite::Generate) do
  include TmpDirIsolation

  def new_stack
    Kite::Core.start(["new", "test"], debug: true)
    Dir.chdir "test"
  end

  def assert_base_stack_files
    expect(Dir).to exist("log")
    expect(Dir).to exist("lib")
    expect(Dir).to exist("lib/tasks")
    expect(Dir).to exist("terraform")
    expect(Dir).to exist("bin")
    expect(Dir).to exist("docs")
    expect(Dir).to exist("config")
    expect(File).to exist("terraform/outputs.tf")
    expect(File).to exist("terraform/terraform.tfvars")
    expect(File).to exist("terraform/main.tf")
    expect(File).to exist("terraform/network.tf")
    expect(File).to exist("terraform/variables.tf")
    expect(File).to exist("bin/setup-tunnel.sh")
    expect(File).to exist("bin/kite")
    expect(File).to exist("docs/index.md")
    expect(File).to exist("docs/quickstart.md")
    expect(File).to exist("Gemfile")
    expect(File).to exist("config/cloud.yml")
  end

  context "Cloud AWS provider" do
    it "generates an IaC" do
      new_stack
      Kite::Generate.start(["cloud", "--provider", "aws"], debug: true)
      assert_base_stack_files

      #Kite::Render.start(["manifest", "bosh", "--cloud", "aws"], debug: true)
      #expect(File).to exist("bosh_vars.yml")
      #expect(File).to exist("terraform/terraform.tfstate")
      #expect(File).to exist("bin/bosh-install.sh")
      #expect(Dir).to exist("deployments")
    end
  end

  context "Cloud GCP provider" do
    it "generates an IaC" do
      new_stack
      Kite::Generate.start(["cloud", "--provider", "gcp"], debug: true)
      assert_base_stack_files
    end
  end
end
