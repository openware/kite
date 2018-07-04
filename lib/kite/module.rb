module Kite
  class Module < Base
    include Kite::Helpers

    method_option :env,     type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    method_option :version, type: :string, desc: "Version", aliases: '-v', required: false
    method_option :method,  type: :string, desc: "Module import method", enum: %w{copy submodule}, default: "submodule"
    desc 'init https://github.com/foo/bar-module', '[DEPRECATED] Use kite module fetch and kite module vars instead'
    def init(path)
      say "Kite module init is deprecated. Use kite module fetch and kite module vars instead", :yellow
    end


    method_option :env,     type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    method_option :version, type: :string, desc: "Version", required: false
    method_option :method,  type: :string, desc: "Module import method", enum: %w{copy submodule}, default: "submodule"
    desc 'fetch https://github.com/foo/bar-module', 'Fetch a kite module'
    def fetch(path)
      @env = options[:env]
      @module_name = path.gsub(/(.*:|.git)/, '').split('/').last
      @module_path = "modules/#{ @module_name }"

      if File.exist?(@module_path)
        overwrite = ask "#{ @module_path } already exists! Overwrite? (y/N)"
        if overwrite.downcase == 'y'
          say "Remove existing files"
          remove_dir(@module_path)
        else
          say "Skipping module init"
          return
        end
      end

      case options[:method]
        when"submodule"
          clone_module(path, @module_path, options[:version])
        when "copy"
          FileUtils.mkdir_p("modules")
          FileUtils.cp_r(path, @module_path)
        else
          raise "Unsupported method #{ method }"
      end
    end

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'vars modules/bar-module', 'Render initial vars.*module*.yml'
    def vars(path)
      @env = options[:env]
      @module_name = path.gsub(/(.*:|.git)/, '').split('/').last
      @module_path = "modules/#{ @module_name }"

      @cloud = parse_cloud_config(@env)
      vars_output = render_vars(@module_name, @module_path)
      say "Rendered successfully #{ vars_output }, please edit this file with correct values", :green
    end

    method_option :env, type: :string, desc: "Environment", required: true, default: ENV['KITE_ENV']
    desc 'render PATH', 'Render kite module files using vars.*module*.yml'
    def render(path)
      @path  = File.expand_path(path)
      @name  = @path.split('/').last
      @env   = options[:env]
      @vars  = load_vars
      @cloud = parse_cloud_config(@env)

      say "Rendering files"
      render_templates
    end

    no_commands do
      def kite_env
        @env
      end

      def clone_module(uri, path, version)
        say "Cloning the module"
        run! "git submodule add #{ uri } #{ path }"
        run! "git submodule init"
        run! "git submodule update"
        unless version.to_s.empty?
          Dir.chdir(path) do
            run! "git checkout #{ version }"
          end
          run! "git add #{ path }"
        end
        say "Successfully init #{ path }!", :green
      end

      def render_vars(module_name, module_path)
        output_file = "config/environments/#{ @env }/vars.#{ module_name }.yml"
        create_file output_file, YAML.dump(manifest(module_path)['variables'])
        output_file
      end

      def render_templates
        directory "#{@path}/templates", ".", mode: :preserve
        chmod     "bin", 0755
      end

      def load_vars
        YAML.load(File.open("config/environments/#{@env}/vars.#{@name}.yml"))
      end

      def manifest(module_path)
        YAML.load(ERB.new(File.read("#{module_path}/manifest.yml.tt")).result(binding))
      end
    end

  end
end
