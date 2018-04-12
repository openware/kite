module Kite
  # Subcommand for generating environments, services etc.
  class Generate < Base
    include Kite::Helpers

    method_option :name, type: :string, desc: "Task name", required: true
    desc "task", "Generate task IaC from configuration"
    def task()
      say "Generating task #{ options[:name] } IaC", :green
    end

    method_option :git, type: :string, desc: "Git repository", required: true
    method_option :name, type: :string, desc: "Name of the service", required: false
    method_option :image, type: :string, desc: "Docker image full name", required: true
    method_option :output, type: :string, desc: "Config output sub-directory", default: "config"
    method_option :slack, type: :string, desc: "Slack notifications", requied: false, default: nil
    method_option :provider, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: false, default: nil
    method_option :image_version, type: :string, desc: "Docker image tag", required: false, default: '0.1.0'
    method_option :chart_version, type: :string, desc: "Chart version", required: false, default: '0.1.0'
    desc "service NAME", "Generate new micro-service pipeline"
    def service(path)
      @name     = options[:name] || File.basename(File.expand_path(path))
      @title    = @name.split(/\W/).map(&:capitalize).join(' ')
      @git      = options[:git]
      @image    = options[:image]
      @provider = options[:provider]
      @output   = options[:output]
      @slack    = options[:slack]
      @image_version = options[:image_version]
      @chart_version = options[:chart_version]

      say "Generating service #{ @name }", :green
      directory('service', path)
    end

    method_option :provider, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc 'environment NAME', 'Generate an environment with base terraform files'
    def environment(name)
      say "Generating environment for #{options[:provider]}"

      unless parse_cloud_config.key? name
        append_to_file 'config/cloud.yml', "\n#{name}:\n  <<: *default\n"
      end

      @cloud = parse_cloud_config(name)
      @env_name = name

      directory("#{options[:provider]}/environment", "config/environments/#{name}")
    end
  end
end
