module Kite::Helpers
  # Check config/cloud.yml file to be complete
  def check_cloud_config(config)
    raise Kite::Error, 'The config/cloud.yml is not filled out!' unless config.find { |key, hash| hash.find { |k, v| v.nil? } }.nil?
  end

  # Check if Terraform IaC was applied
  def check_terraform_applied
    raise Kite::Error, 'Did you terraform apply? terraform.tfstate is missing!' unless File.file? "terraform/terraform.tfstate"
  end

  def render_range(from, to, range)
    range[from].to_s + '-' + range[to].to_s
  end

end
