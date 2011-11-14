class Project < ActiveRecord::Base
  has_many :apps
  has_many :customizations, :as => :customizable
  
  validates_presence_of :name, :name_tag
  before_validation :clean_keys
  
  after_save :update_apps
  
  def configuration
    attributes.symbolize_keys.extract!(:name,:name_tag,:homepage,:repository,:repo_private_key)
  end
  
  def update_apps
    apps.each {|a|a.touch }
  end
  
  private
    # Fix newlines and trailing lines
    def clean_keys
      self.repo_private_key = clean_key(repo_private_key)
    end
    
    def clean_key(key)
      key.to_s.gsub(/\r\n/, "\n").strip
    end
    
end
