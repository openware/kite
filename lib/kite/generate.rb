module Kite
  # Subcommand for rendering manifests, deployments etc.
  class Generate < Base
    include Kite::Helpers

    method_option :provider, type: :string, desc: "Cloud provider", enum: %w{aws gcp}, required: true
    desc "cloud", "Generate cloud IaC from configuration"
    # Generates Infrastructure as Code and setup scripts for the given cloud using values from <b>config/cloud.yml</b>
    def cloud()
      say "Generating cloud #{ options[:provider] } IaC", :green
      @values = parse_cloud_config

      case options[:provider]
        when 'aws'
          directory('aws/terraform',                          'terraform')
          copy_file('aws/README.md',                          'README.md', force: true)
          copy_file('aws/docs/kops.md',                       'docs/kops.md')

          directory('aws/bin/base',                           'bin')
          template('aws/bin/kops-deploy.sh.erb',              'bin/kops-deploy.sh')
          template('aws/bin/kops-delete.sh.erb',              'bin/kops-delete.sh')
          chmod('bin/bootstrap.sh', 0755)
          chmod('bin/cleanup.sh', 0755)
          chmod('bin/setup-tunnel.sh', 0755)
          chmod('bin/kops-deploy.sh', 0755)
          chmod('bin/kops-delete.sh', 0755)

        when 'gcp'
          directory('gcp/terraform',                          'terraform')
          copy_file('gcp/README.md',                          'README.md', force: true)


          directory('gcp/bin/base',                           'bin')
          chmod('bin/bootstrap.sh', 0755)
          chmod('bin/cleanup.sh', 0755)
          chmod('bin/setup-tunnel.sh', 0755)

        else
          say 'Cloud provider not specified'

      end
    end

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
      @env_name = name
      @values   = parse_cloud_config[name]

      say "Generating environment for #{options[:provider]}"
      directory("#{options[:provider]}/environment", "config/environments/#{name}")
    end

    no_commands do
      def output_path
        @output ||= "config"
      end

      def app_name
        @name ||= "app-name"
      end
    end

  end
end
