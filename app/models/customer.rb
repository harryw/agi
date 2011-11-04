class Customer < ActiveRecord::Base
    has_many :apps
    
    validates_presence_of :name, :name_tag
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:name_tag)
    end
end
