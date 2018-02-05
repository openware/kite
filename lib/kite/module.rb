module Kite
  class Module < Base
    include Kite::Helpers

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'init https://github.com/foo/bar-module', 'Initialize a kite module and render its vars.module.yml'
    def init(uri)
      @uri  = uri
      @name = uri.gsub(/(.*:|.git)/, '').split('/').last
      @path = "modules/#{@name}"
      @env  = options[:env]

      say "Cloning the #{@name} module"
      clone_module

      say "Rendering vars"
      render_vars

      say "Use git submodule add #{@path} to be able to commit this module as a submodule", :yellow
      say "Rendered successfully, please fill out config/environments/#{@env}/vars.#{@name}.yml with correct values", :green
    end

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'render PATH', 'Render kite module files using vars.*module*.yml'
    def render(path)
      @path  = path
      @name  = @path.split('/').last
      @env   = options[:env]
      @vars  = load_vars
      @cloud = parse_cloud_config[@env]

      say "Rendering files"
      render_templates
    end

    no_commands do
      def kite_env
        @env
      end

      def clone_module
        if File.exist? @path
          overwrite = ask "#{@path} already contains a module! Overwrite? (y/n)"

          if overwrite.downcase == 'y'
            remove_dir @path
            Git.clone(@uri, @path)
          end
        else
          Git.clone(@uri, @path)
        end
      end

      def render_vars
        create_file "config/environments/#{@env}/vars.#{@name}.yml", YAML.dump(manifest['variables'])
      end

      def render_templates
        directory "#{ENV['PWD']}/modules/#{@name}/templates", ".", mode: :preserve
        chmod     "bin", 0755
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
