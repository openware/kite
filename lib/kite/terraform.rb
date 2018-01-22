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
      @vars.each do |var, val|
        key = "TF_VAR_#{var}"
        ENV[key] = val
        STDERR.puts "%-25s: %s" % [key, ENV["TF_VAR_#{var}"]]
      end

      # TODO: Need to be set only in case of GCP
      ENV['GOOGLE_APPLICATION_CREDENTIALS'] = @vars["credentials"]
    end

    def cloud
      YAML.load(File.read('config/cloud.yml'))[@env_name]
    end

    def load_vars
      vars_files = Dir["config/environments/#{@env_name}/vars.*.yml"]
      @vars = Hash.new
      vars_files.each do |f|
        @vars.merge!(YAML.load(File.read(f)))
      end
    end
  end
end
