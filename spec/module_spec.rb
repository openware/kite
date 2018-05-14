require "spec_helper"
require 'tmpdir'

RSpec.describe Kite::Module do
  include TmpDirIsolation

  def validate_module(name)
    expect(File).to be_directory("modules")
    expect(File).to be_directory("modules/#{ name }")
    expect(File).to exist("modules/#{ name }/README.md")
    expect(File.read("modules/#{ name }/README.md")).to eq("hello\n")
  end

  context("local module") do
    before(:each) do
      init_git_local("kite-super-module")
      init_kite_project("kite-project")
    end

    it "imports as submodule and init" do
      Dir.chdir("kite-project") do
        run "#{ KITE_BIN } module import ../kite-super-module"
        expect(File).to be_file("modules/kite-super-module/.git")
        validate_module "kite-super-module"

        run "#{ KITE_BIN } module init --env qa ./modules/kite-super-module"
        expect(File).to be_file("config/environments/qa/vars.kite-super-module.yml")
      end
    end

    it "imports by copying the directory" do
      Dir.chdir("kite-project") do
        run "#{ KITE_BIN } module import ../kite-super-module --method=copy"
        expect(File).to_not be_file("modules/kite-super-module/.git")
        validate_module "kite-super-module"
      end
    end
    
  end  
end
