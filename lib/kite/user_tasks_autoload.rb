module UserCommand; end

module Kite
  module UserTasksAutoload
    def self.included(base)
      commands = Dir.glob("./lib/tasks/*.rb")
      commands.each do |command|
        require command
        command_name = File.basename(command).gsub(/\.rb$/, '')
        klass = UserCommand.const_get(command_name.capitalize)
        desc = klass.respond_to?(:description) ? klass.description : "#{ command_name.capitalize } sub command"
        base.desc(command_name, desc)
        base.subcommand command_name, klass
      end
    end
  end
end

