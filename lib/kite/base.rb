# Base class including all Thor-related configuration
class Kite::Base < Thor

  include Thor::Actions

  def self.exit_on_failure?
    true
  end

  def self.source_root
    File.expand_path(File.join(File.dirname(__FILE__), "../../tpl"))
  end

end
