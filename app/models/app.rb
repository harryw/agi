class App < ActiveRecord::Base
    has_many :deployments
    
    def databag_item_timestamp 
        self.deployments.last.try(:deployment_timestamp)
    end
    
    def app_timestamp
        self.updated_at
    end
    
    def generate_deployment_data
        to_json
    end
end
