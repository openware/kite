module Kite::Helpers
  # Check config/cloud.yml file to be complete
  def check_cloud_config(config)
    raise Kite::Error, 'The config/cloud.yml is not filled out!' unless config.find { |key, hash| hash.find { |k, v| v.nil? } }.nil?
  end

  # Check if Terraform IaC was applied
  def check_terraform_applied
    raise Kite::Error, 'Did you terraform apply? terraform.tfstate is missing!' unless File.file? "terraform/terraform.tfstate"
  end

  # Parse Terraform .tfstate file, returning the output hash
  def parse_tf_state(path)
    check_terraform_applied

    tf_state = YAML.load(File.read(path))
    tf_output = tf_state["modules"].first["outputs"]
    tf_output.map { |k, v| tf_output[k] = v["value"] }

    tf_output
  end

  # Parse config/cloud.yml, returning the output hash
  def parse_cloud_config
    cloud_config = YAML.load(File.read('config/cloud.yml'))
    check_cloud_config(cloud_config)

    cloud_config
  end

  # Returns subnet's IP range slice in a BOSH manifest-compatible way
  def ip_range(subnet, range)

    subnet = subnet.to_a # Turn subnet into array representation to be DRY

    case range
    when Integer
      raise Kite::Error, 'Range number less than one in ip_range()' if range < 1

      subnet[0].to_s + '-' + subnet[range].to_s

    when Array
      raise Kite::Error, 'Invalid number of elements in ip_range()' unless range.length == 2
      raise Kite::Error, 'Second index is less than the first one in ip_range()' if range.last < range.first

      subnet[range.first].to_s + '-' + subnet[range.last].to_s

    when Range
      raise Kite::Error, 'Second index is less than the first one in ip_range()' if range.last < range.first

      range = range.to_a
      subnet[range.first].to_s + '-' + subnet[range.last].to_s

    else
      raise Kite::Error, 'Unsupported range type for ip_range()'
    end
  end

end
