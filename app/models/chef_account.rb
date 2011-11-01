class ChefAccount < ActiveRecord::Base
  has_many :apps

  before_validation :clean_keys
  after_save        :remove_client_key
  after_destroy     :remove_client_key
  
  validates_presence_of :name, :validator_key, :client_key, :api_url
  
  def update_data_bag_item(data_bag_item_data)
    begin
      puts 'tryting to save the databag'
      rest.post_rest("data/#{data_bag_name}", data_bag_item_data)
    rescue Net::HTTPServerException
      if $!.message == '404 "Not Found"' && !@tried_to_create_databag
        puts 'creating the databag'
        create_databag
        retry
      else
        raise
      end
    end
  end
  
  def create_databag
    @tried_to_create_databag = true
    rest.post_rest('/data', 'name' => data_bag_name)
  end
  
  def data_bag_name
    'application_environment'
  end
  
  def validator_name
    "#{name}-validator"
  end

  def api_url
    "https://api.opscode.com/organizations/#{name}"
  end

  def rest
    @rest ||= Chef::REST.new(api_url, client_name, get_client_key_path)
  end

  def client_key_path
    @client_key_path ||= Rails.root.join("tmp", "chef_account_#{id}_client.pem")
  end

  # Ensure the client_key_path exists
  def get_client_key_path
    File.open(client_key_path, 'w'){ |f| f.write(client_key) }
    client_key_path
  end
  
  private
    # Fix newlines and trailing lines
    def clean_keys
      self.validator_key = clean_key(validator_key)
      self.client_key    = clean_key(client_key)
      self.databag_key   = clean_key(databag_key)
    end
    
    def clean_key(key)
      key.to_s.gsub(/\r\n/, "\n").strip
    end
    
    def remove_client_key
      FileUtils.rm_f(client_key_path)
    end
  
end
