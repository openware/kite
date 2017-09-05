module Kite::Helpers
  # Check config/cloud.yml file to be complete
  def check_cloud_config(config)
    if config.find { |key, hash| hash.find { |k, v| v.nil? } }.nil?
      say "Cloud config check successful", :green
      true
    else
      say "Cloud config is not fully filled out!", :red
      false
    end
  end

  # Check if Terraform IaC was applied
  def check_terraform_applied
    is_applied = File.file? "terraform/terraform.tfstate"
    say ".tfstate file is not present, did you terraform apply?", :red unless is_applied
    is_applied
  end

  # Parse Terraform .tfstate file, returning the output hash
  def parse_tf_state(path)
    tf_state = YAML.load(File.read(path))
    tf_output = tf_state["modules"].first["outputs"]
    tf_output.map { |k, v| tf_output[k] = v["value"] }
    tf_output
  end

end
