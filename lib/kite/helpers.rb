module Kite::Helpers
  # Check config/cloud.yml file to be complete
  def check_cloud_config(config)
    raise Kite::Error, 'The config/cloud.yml is not filled out!' unless config.find { |key, hash| hash.find { |k, v| v.nil? } }.nil?
  end

  def cloud_valid?(path)
    valid = Dir.children(path).include? 'config'
    valid &&= Dir.children(path + '/config').include? 'cloud.yml'

    valid
  end

  def cloud_path
    Dir.pwd.tap do |path|
      until cloud_valid? path
        raise Kite::Error, "Invalid path: \"#{Dir.pwd}\"" if path == "/"
        path = File.dirname(path)
      end
    end
  end

  # Parse config/cloud.yml, returning the output hash
  def parse_cloud_config(env = nil)
    cloud_config = YAML.load(File.read('config/cloud.yml'))
    check_cloud_config(cloud_config)

    if env
      unless cloud_config[env]
        fail "Environement `#{env}` missing in config/cloud.yml"
      end
      return cloud_config[env]
    end
    return cloud_config
  end

  def run!(command, config = {})
    run(command)

    if $?.exitstatus != 0
      raise Thor::Error.new("command failed: #{ command }")
    end
  end
end
