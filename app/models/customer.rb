class Customer < ActiveRecord::Base
    has_many :apps
    has_many :customizations, :as => :customizable
    
    validates_presence_of :name, :name_tag
    
    after_save :update_apps
    
    
    def update_apps
      apps.each {|a|a.touch }
    end
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:name_tag)
    end
end
