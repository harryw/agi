class Project < ActiveRecord::Base
  has_many :apps
  has_many :customizations, :as => :customizable
  
  validates_presence_of :name, :name_tag
  before_validation :clean_keys
  
  after_save :update_apps
  
  def configuration
    attributes.symbolize_keys.extract!(:name,:name_tag,:homepage,:repository,:repo_private_key).merge(:custom_data => custom_data).reject{|k,v| v.blank? }
  end
  
  def update_apps
    apps.each {|a|a.touch }
  end
  
  def custom_data
    data = customizations.where(:location=> "").where(:prompt_on_deploy => false)
    Hash[*data.map {|c| c.attributes.symbolize_keys.extract!(:name,:value).values }.flatten]
  end

# please make the private key from medidata load on start
#  def repo_private_key
#   DEPLOYER_KEY 
#  end

  private
    # Fix newlines and trailing lines
    def clean_keys
      self.repo_private_key = clean_key(repo_private_key)
    end
    
    def clean_key(key)
      key.to_s.gsub(/\r\n/, "\n").strip
    end
    
end
