class Customer < ActiveRecord::Base
    has_many :apps
    has_many :customizations, :as => :customizable
    
    validates_presence_of :name, :name_tag
    
    after_save :update_apps
    
    attr_accessible :name_tag, :name
    
    def update_apps
      apps.each {|a|a.touch }
    end
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:name_tag).merge(:custom_data => custom_data).reject{|k,v| v.blank? }
    end
    
    def custom_data
      data = customizations.where(:location=> "").where(:prompt_on_deploy => false)
      Hash[*data.map {|c| c.attributes.symbolize_keys.extract!(:name,:value).values }.flatten]
    end
end
