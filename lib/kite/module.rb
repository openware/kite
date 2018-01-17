module Kite
  class Module < Base
    include Kite::Helpers

    method_option :env, type: :string, desc: "Environment", required: true
    desc 'init NAME https://github.com/foo/bar-module', 'Initialize a kite module and render its vars.module.yml'
    def init(name, uri)
      @name = name
      @env  = options[:env]

      say "Cloning the #{@name} module"
      clone_module("modules/#{@name}", uri)

      say "Rendering vars"
      render_vars

      say "Rendered successfully, please fill out config/environments/#{@env}/vars.#{@name}.yml with correct values", :green
    end

    method_option :env, type: :string, desc: "Environment", required: true
    desc 'render NAME', 'Render kite module files using vars.*module*.yml'
    def render(name)
      @name = name
      @env  = options[:env]
      @vars = load_vars


      say "Rendering files"
      render_templates
    end

    no_commands do
      def clone_module(path, uri)
        if File.exist? path
         overwrite = ask "#{path} already contains a module! Overwrite? (y/n)"

         if overwrite.downcase == 'y'
           remove_dir path
           Git.clone(uri, path)
         end
        end
      end

      def render_vars
        create_file "config/environments/#{@env}/vars.#{@name}.yml", YAML.dump(manifest['variables'])
      end

      def render_templates
        directory "#{ENV['PWD']}/modules/#{@name}/templates", "config/environments/#{@env}"
      end

      def load_vars
        YAML.load(File.open("config/environments/#{@env}/vars.#{@name}.yml"))
      end

      def manifest
        YAML.load(File.open("modules/#{@name}/manifest.yml"))
      end
    end

  end
end
