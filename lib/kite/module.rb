module Kite
  class Module < Base
    include Kite::Helpers

    method_option :env,     type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    method_option :version, type: :string, desc: "Version", required: false
    desc 'init https://github.com/foo/bar-module', 'Initialize a kite module and render its vars.module.yml'
    def init(path)
      @env     = options[:env]
      @path    = path
      @name    = path.gsub(/(.*:|.git)/, '').split('/').last
      @cloud   = parse_cloud_config[@env]
      @version = options[:version]

      unless File.exist? path
        @uri  = path
        @path = "modules/#{@name}"

        clone_module
        unless @version.nil?
          checkout_version
        end

        say "Use git submodule add #{@path} to be able to commit this module as a submodule", :yellow
      end

      render_vars

      say "Rendered successfully, please fill out config/environments/#{@env}/vars.#{@name}.yml with correct values", :green
    end

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'render PATH', 'Render kite module files using vars.*module*.yml'
    def render(path)
      @path  = File.expand_path(path)
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
        say "Cloning the module"

        if File.exist? @path
          overwrite = ask "#{@path} already contains a module! Overwrite? (y/N)"

          if overwrite.downcase == 'y'
            remove_dir @path
            Git.clone(@uri, @path)
            say "Successfully cloned the fresh #{@name}!", :green
          else
            say "Keeping the current module revision"
          end
        else
          Git.clone(@uri, @path)
        end
      end

      def checkout_version
        module_git = Git.open(@path)

        say "Switching to #{@version}"
        if @version =~ /\d+\.\d+\.\d+/ && module_git.tags.any? { |t| t.name == @version }
          module_git.checkout("tags/#{@version}")
        elsif module_git.is_remote_branch? @version
          module_git.checkout("origin/#{@version}")
        else
          say "#{@version} tag/branch was not found in the module, keeping the current one", :red
        end
      end

      def render_vars
        create_file "config/environments/#{@env}/vars.#{@name}.yml", YAML.dump(manifest['variables'])
      end

      def render_templates
        directory "#{@path}/templates", ".", mode: :preserve
        chmod     "bin", 0755
      end

      def load_vars
        YAML.load(File.open("config/environments/#{@env}/vars.#{@name}.yml"))
      end

      def manifest
        YAML.load(ERB.new(File.read("#{@path}/manifest.yml.tt")).result(binding))
      end
    end

  end
end
