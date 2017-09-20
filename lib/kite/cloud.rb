# Class responsible for creating a new cloud infrastructure skeleton
class Kite::Cloud

  include Kite::Helpers

  def self.instance
    @@instance
  end

  def init_core(core, cloud_name)
    @core = core
    @name = cloud_name
    @core.destination_root = nil
  end

  def name
    @name
  end

  def core
    @core
  end

  # Parse config/cloud.yml, returning the output hash
  def cloud_conf
    cloud_config = YAML.load(File.read('config/cloud.yml'))
    check_cloud_config(cloud_config)

    cloud_config
  end

  # Parse Terraform .tfstate file, returning the output hash
  def tf_output
    check_terraform_applied

    tf_state = YAML.load(File.read('terraform/terraform.tfstate'))
    tf_output = tf_state["modules"].first["outputs"]
    tf_output.map { |k, v| tf_output[k] = v["value"] }

    tf_output
  end

  # Returns ip address range from cloud config
  def private_subnet
    network_cidr = cloud_conf['aws']['private_subnet']['network']
    IPAddr.new(network_cidr).to_range.to_a
  end

  def prepare
    core.directory('skel', name)
    core.inside(name) do
      core.chmod('bin/kite', 0755)
    end
  end

  @@instance = Kite::Cloud.new

  private_class_method :new
end
