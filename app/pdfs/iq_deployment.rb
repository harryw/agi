class IqDeployment < Prawn::Document
  FILTERED_KEYS = %w{ password }
  
  def initialize(deployment)
    super()
    @deployment = deployment
    text iq_data
  end
  
  def iq_data
    JSON.pretty_generate(JSON.parse(filter_deployed_data.to_json))
  end
  
  def filter_deployed_data
    strip_value(@deployment.deployed_data, :password)
    @deployment.deployed_data
  end
  
  # Removes any key/value pair from the Hash-of-Hashes deep_hash,
  # whose key is secret_key, no matter how deeply nested
  def strip_value(deep_hash, secret_key)
    deep_hash.reject do |key, value|
      deep_hash[key] = strip_value(value, secret_key) if value.is_a? Hash
      key == secret_key
    end
  end
  
end