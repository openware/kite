module Kite
  class Module < Base
    include Kite::Helpers

    method_option :env, type: :string, desc: "Environment", required: true
    desc 'init', 'Initialize a kite module and render its vars.module.yml'
    def init(name, uri)
      say "Cloning the #{name} module"
      clone_module("modules/#{name}", uri)

      say "Rendering vars"
      render_vars(name, options[:env])

      say "Rendered successfully, please fill out config/environments/#{options[:env]}/vars.#{name}.yml with correct values", :green
    end

    no_commands do
      def clone_module(path, uri)
        remove_dir path if File.exist? path
        Git.clone(uri, path)
      end

      def render_vars(name, env)
        manifest = load_manifest(name)
        create_file "config/environments/#{options[:env]}/vars.#{name}.yml", YAML.dump(manifest['variables'])
      end

      def load_manifest(name)
        YAML.load(File.open("modules/#{name}/manifest.yml"))
      end
    end

  end
end
