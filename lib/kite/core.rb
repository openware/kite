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

    desc 'render MANIFEST', 'Render manifest file from configuration and Terraform output'
    subcommand "render", Kite::Render

    desc 'module', 'Use kite modules with environments'
    subcommand "module", Kite::Module

    desc 'terraform', 'Use Terraform-related operations'
    subcommand "terraform", Kite::Terraform

    desc "version", "Return kite version"
    # Return kite version
    def version
      say "v#{ Kite::VERSION }"
    end
  end
end
