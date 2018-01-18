module Kite
  class Terraform < Base
    include Kite::Helpers

    method_option :provider, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc "apply", "Apply Terraform files in a chosen environment"
    def apply(env_name)
      say "Loading env"
      @env_name = env_name
      load_env
      say "Initializing terraform"
      initialized = system "terraform init config/environments/#{env_name}"

      if initialized
        say "Applying terraform"
        system "terraform apply config/environments/#{env_name}"
      end
    end

    no_commands do
      def load_env
        load_vars
        @vars.each do |var, val|
          puts var, val
          ENV["TF_VAR_#{var}"] = val
          p "value: #{ENV["TF_VAR_#{var}"]}"
        end
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
end
