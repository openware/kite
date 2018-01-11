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

  # Parse terraform.tfvars, returning the output hash
  def parse_tf_vars()
    raise Kite::Error, 'Are you in the env directory? terraform.tfvars is missing!' unless File.file? 'terraform.tfvars'

    lines = File.read('terraform.tfvars').lines.select { |line| line[0] != "#" && line != "\n" } # Read all lines excluding comments and blank lines
    lines.map { |line| line.tr!("\"", ""); line.tr!("\n", "") } # Strip the lines of quotes and line breaks

    res_vars = Hash.new
    lines.map { |line| line.split(" = ") }.each { |line| res_vars[line.first] = line.last } # Convert all variables into a hash

    res_vars
  end

  # Parse config/cloud.yml, returning the output hash
  def parse_cloud_config
    cloud_config = YAML.load(File.read('config/cloud.yml'))
    check_cloud_config(cloud_config)

    cloud_config
  end

  # Return public subnet id depending on
  # whether it's declared in config/cloud.yml or not
  def conditional_subnet_id(values)
    subnet_id = values['aws']['public_subnet']['id']

    if subnet_id.empty?
      '${aws_subnet.platform_dmz.id}'
    else
      subnet_id
    end
  end

  # Return vpc id depending on
  # whether it's declared in config/cloud.yml or not
  def conditional_vpc_id(values)
    vpc_id = values['aws']['vpc_id']

    if vpc_id.empty?
      '${aws_vpc.platform.id}'
    else
      vpc_id
    end
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
