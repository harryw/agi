class App < ActiveRecord::Base
    has_many :deployments
    belongs_to :customer
    belongs_to :project
    
    
    delegate :name, :formal_name, :to => :project, :prefix => true, :allow_nil => true
    delegate :name, :formal_name, :to => :customer, :prefix => true, :allow_nil => true
    
    #TODO scope sucessful
    
    # Rename this function
    def databag_item_timestamp
        # TODO, last sucessful deployment 
        self.deployments.last.try(:deployment_timestamp)
    end
    
    def app_timestamp
        self.updated_at
    end
    
    def generate_deployment_data
        to_json
    end
end
