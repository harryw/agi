class App < ActiveRecord::Base
    
    belongs_to :customer
    belongs_to :project
    belongs_to :database

    has_many :deployments
    
    delegate :name, :name, :to => :project,  :prefix => true, :allow_nil => true
    delegate :name, :name, :to => :customer, :prefix => true, :allow_nil => true
    delegate :name, :name, :to => :database, :prefix => true, :allow_nil => true
    
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
