class IqDeployment < Prawn::Document
  FILTERED_KEYS = [:password, :repo_private_key]
  
  def initialize(deployment,deployed_time=Time.now)
    super()
    @deployment = deployment
    @data_bag = @deployment.deployed_data
    @deployed_time = deployed_time
    iq_header
    iq_data
  end
  
  def iq_header
    text "MEDIDATA IQ"
    text " "
    text "FOR APPLICATION #{@data_bag[:main][:name]}"
    text "Deployment time: #{@deployed_time}"
    text "----------------------------------------------------"
    text "Last Deployed by: #{@data_bag[:main][:deploy_by]}"
    text " "
    text "Repository: #{@data_bag[:project][:repository]}"
    text "Commit/Branch/Tag: #{@data_bag[:main][:git_branch]}"
    text " "
    text "Application Platform: #{@data_bag[:main][:platform]}"
    text "Application URL: #{@data_bag[:project][:homepage]}"
    text "Deploy User: #{@data_bag[:main][:deploy_user]} Deploy Group: #{@data_bag[:main][:deploy_group]}"
    text " "
    if @data_bag[:database]
      text "DB Host: #{@data_bag[:database][:hostname]}"
      text "DB Name: #{@data_bag[:database][:db_name]}"
      text "DB User: #{@data_bag[:database][:username]}"
      text "DB Type: #{@data_bag[:database][:db_type]}"
    else
      text "None Database was specified"
    end
    text "----------------------------------------------------"
  end
  
  def iq_data
    text "Data Bag Content:"
    text JSON.pretty_generate(JSON.parse(filter_deployed_data.to_json))
  end
  
  def filter_deployed_data
    FILTERED_KEYS.each do |filter_key|
      # @data_bag is modified by strip_value
      strip_value(@data_bag, filter_key)
    end
    @data_bag
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