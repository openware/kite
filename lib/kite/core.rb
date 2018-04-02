module Kite
  class Core < Base

    include Kite::Helpers

    desc "new CLOUD_PATH", "Generate Cloud infrastructure skeleton from configuration"
    # Creates a cloud infrastructure skeleton with a given name
    def new(cloud_name)
      target = Kite::Cloud.new(self, cloud_name)
      target.prepare
    end

    desc "generate", "Generate IaC from configuration"
    subcommand "generate", Kite::Generate

    desc 'module', 'Use kite modules with environments'
    subcommand "module", Kite::Module

    desc 'exec', 'Run  a command with environment variables loaded from cloud.yml'
    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    def exec(*args)
      Kite::Exec.new(self, options).run(*args)
    end

    desc 'terraform', 'Run Terraform-related commands with environment variables loaded from module vars'
    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    def terraform(command, *args)
      Kite::Terraform.new(self, options).run(command, *args)
    end

    desc "version", "Return kite version"
    # Return kite version
    def version
      say "v#{ Kite::VERSION }"
    end
  end
end
