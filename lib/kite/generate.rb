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

          directory('aws/bin/base',                           'bin')
          chmod('bin/bootstrap.sh', 0755)
          chmod('bin/cleanup.sh', 0755)

        when 'gcp'
          directory('gcp/terraform',                          'terraform')
          copy_file('gcp/README.md',                          'README.md', force: true)


          directory('gcp/bin/base',                           'bin')
          chmod('bin/bootstrap.sh', 0755)
          chmod('bin/cleanup.sh', 0755)

        else
          say 'Cloud provider not specified'

      end
    end

    method_option :force, type: :boolean, desc: "Overwrite existing commands", default: false
    desc "task COMMAND_NAME [TASK_NAME, ...]", "Generate task IaC from configuration"
    def task(command_name, *tasks)
      command_file = "lib/tasks/#{ command_name.downcase }.rb"
      @command_name = command_name.capitalize

      if !File.exists?(command_file) or options[:force]
        say "Generating task #{ options[:name] } IaC", :green
        template("tasks/command.rb.erb", command_file)
      end

      tasks.each do |task|
        task = task.downcase
        command_code = File.read(command_file)
        if command_code =~ /desc '#{ task }'/
          STDERR.puts "Command #{ task } already exists!"
          exit 1
        end

        inject_into_class(command_file, "UserCommand::#{ @command_name }") do
<<EOF

  desc '#{ task }', '#{ task.capitalize } task'
  def #{ task }
    say 'running task #{ task }'
  end

EOF
        end
      end
    end
  end
end
