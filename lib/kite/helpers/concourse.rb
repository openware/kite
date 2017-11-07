require 'json'
require 'open3'

module Kite
  module Helpers
    # Helpers for concourse scripts
    module Concourse
      def self.params(data)
        JSON.parse data
      end

      def self.log(msg)
        msg.split("\n").each { |line| $stderr.puts("[LOG] --- #{line}") }
      end

      def self.respond(data)
        # keep only valid concourse values
        data.select! { |k, _| k.to_s =~ /(version|metadata)/ }
        puts JSON.dump(data)
      end

      def self.fatal(message)
        respond(version: { status: 'error' }, metadata: [message])
        exit 1
      end

      def self.execute(command, env = {})
        log("+ #{ command }")
        Open3.popen2e(env, command) do |stdin, stdout, wait_thr|
          ::Kite::Helpers::Concourse.log(stdout.read)
          return wait_thr.value.exitstatus.zero?
        end
      end
    end
  end
end
