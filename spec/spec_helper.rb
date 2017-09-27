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

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
