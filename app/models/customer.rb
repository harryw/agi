class Customer < ActiveRecord::Base
    has_many :apps
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:name_tag)
    end
end
