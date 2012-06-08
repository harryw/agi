class IqDeployment < Prawn::Document
  FILTERED_KEYS = [:password, :repo_private_key]
  
  def initialize(deployed_data,deployed_time=Time.now)
    super(:page_layout => :landscape)
    @data_bag = deployed_data
    @deployed_time = deployed_time
    #iq_header
    iq_data
    
  end
  
  def iq_data
    
    image "#{Rails.root}/app/assets/images/medidata.png", :position => 450, :vposition => 5
    
    text "<b>MEDIDATA IQ</b>", :size => 12, :style => :bold, :inline_format => true
    text " "
    text "FOR APPLICATION #{@data_bag[:main][:name]}", :size => 9,  :inline_format => true
    
    text " "
    data = [["Parameter", "Value"]] 
    data += [["Deployment time:", "#{@deployed_time}"]]
    data += [["Last Deployed by:", "#{@data_bag[:main][:deploy_by]}"]]
    data += [["Repository:", "#{@data_bag[:project][:repository]}"]]
    data += [ ["Commit/Branch/Tag:", "#{@data_bag[:main][:git_branch]}"]]
    data += [ ["Application Platform:", "#{@data_bag[:main][:platform]}"]]
    data += [["Application URL:", "#{@data_bag[:project][:homepage]}"]]
    data += [["Deploy User:", "#{@data_bag[:main][:deploy_user]}"]]
    data += [["Deploy Group:", "#{@data_bag[:main][:deploy_group]}"]]
    if @data_bag[:database]
      data += [["DB Host:", "#{@data_bag[:database][:hostname]}"]]
      data += [["DB Name:", "#{@data_bag[:database][:db_name]}"]]
      data += [["DB User:", "#{@data_bag[:database][:username]}"]]
      data += [["DB Type:", "#{@data_bag[:database][:db_type]}"]]
    else
      data += [["No Database was specified"]]
    end
    data += [["Data Bag Content:", JSON.pretty_generate(JSON.parse(filter_deployed_data.to_json))]]
    table(data, :header => true, :width => 700, :cell_style => {:border_color => "cccccc", :size => 9})
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