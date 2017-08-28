module Kite::Helpers
  # Parse Terraform .tfstate file, returning the output hash
  def parse_tf_state(path)
    tf_state = YAML.load(File.open(path))
    tf_output = tf_state["modules"].first["outputs"]
    tf_output.map { |k, v| tf_output[k] = v["value"] }
    tf_output
  end
end
