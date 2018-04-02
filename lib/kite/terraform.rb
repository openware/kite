module Kite
  class Terraform

    def initialize(core, options)
      @core = core
      @env_name = options[:env]
    end

    def run(command, *args)
      STDERR.puts "Loading env"
      load_env
      script = "terraform #{command} #{args.join " "}"
      STDERR.puts script

      Dir.chdir("config/environments/#{@env_name}") do
        system(script)
      end
    end

    def load_env
      load_vars
      load_cloud
      @vars.each do |var, val|
        key = "TF_VAR_#{var}"
        ENV[key] = val
        STDERR.puts "%-25s: %s" % [key, ENV["TF_VAR_#{var}"]]
      end

      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = File.expand_path(@vars["service_account"]) if cloud.key? 'gcp'
    end

    def cloud
      YAML.load(File.read('config/cloud.yml'))[@env_name]
    end

    def load_cloud
      cloud.each do |k, v|
        (v.is_a? Hash) ? @vars.merge!(v) : @vars[k] = v
      end
    end

    def load_vars
      @vars = Hash.new
      vars_files = Dir["config/environments/#{@env_name}/vars.*.yml"]
      vars_files.each do |f|
        tf_vars = YAML.load(File.read(f))['terraform']
        @vars.merge!(tf_vars) unless tf_vars.nil?
      end
    end
  end
end
