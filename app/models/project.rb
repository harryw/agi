class Project < ActiveRecord::Base
    has_many :apps
    
    def configuration
        attributes.symbolize_keys.extract!(:name,:name_tag,:homepage,
                                            :respository,:repo_private_key)
    end
end
