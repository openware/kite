module Kite
  class Exec

    def initialize(core, options)
      @core = core
      @env_name = options[:env]
    end

    def run(*args)
      STDERR.puts "Loading env"
      load_env
      script = "#{args.join " "}"
      STDERR.puts script

      system(script)
    end

    def load_env
      cloud['env'].each do |var, val|
        ENV[var] = val
        STDERR.puts "%-15s: %s" % [var, ENV["#{var}"]]
      end
    end

    def cloud
      YAML.load(File.read('config/cloud.yml'))[@env_name]
    end
  end
end
