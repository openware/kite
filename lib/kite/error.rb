module Kite::Error
  class TerraformNotApplied < Thor::Error
    def to_s
      'Did you terraform apply? terraform.tfstate is missing!'
    end
  end
  class CloudConfigInvalid  < Thor::Error
    def to_s
      'The config/cloud.yml is not filled out!'
    end
  end
end
