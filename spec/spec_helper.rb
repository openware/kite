if ENV["COVERAGE"] == "true"
  require 'simplecov'
  require 'codecov'
  SimpleCov.start do
    load_profile "test_frameworks"
    add_group "Templates", "tpl"
    add_group "Lib", "lib"
    track_files "{lib,bin,tpl}/**/*.{rb,erb}"
  end
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require "bundler/setup"
require "kite"
require "pp"
require "open3"

KITE_ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
KITE_BIN = File.join(KITE_ROOT, "bin/kite")

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

   def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  alias silence capture

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def run(command, opts = {})
    opts = {silent: false, raise_error: true, env: ENV.to_h}.merge(opts)
    return_value = nil
    Open3.popen3(opts[:env], command) do |_, stdout, stderr, wait_thr|
      unless opts[:silent]
        $stdout.print stdout.read
        $stderr.print stderr.read
      end
      return_value = wait_thr.value
    end
    if opts[:raise_error] and !return_value.success?
      raise "Command `#{ command }` failed with status #{ return_value }"
    end
    return_value.success?
  end
end

module TmpDirIsolation
  def self.included(base)
    base.before(:each) do
      @old_dir = Dir.pwd
      @tmp_dir = Dir.mktmpdir
      Dir.chdir(@tmp_dir)
    end

    base.after(:each) do
      Dir.chdir(@old_dir)
      FileUtils.rm_rf(@tmp_dir)
    end
  end
end
