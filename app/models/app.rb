class App < ActiveRecord::Base
    
    belongs_to :customer
    belongs_to :project
    belongs_to :database
    belongs_to :chef_account

    has_many :deployments
    
    delegate :name, :configuration, :to => :project, :prefix => true, :allow_nil => true
    delegate :name, :configuration, :to => :customer,:prefix => true, :allow_nil => true
    delegate :name, :configuration, :to => :database,:prefix => true, :allow_nil => true
    delegate :name, :update_data_bag_item, :to => :chef_account, :prefix => true, :allow_nil => true
    
    #serialize :deployed_data
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
        data_bag_item_data #.to_json
    end
    def configuration
        attributes.symbolize_keys.extract!(:name,:stage_name,:deploy_to,:deploy_user,:deploy_group,:multi_tenant,
                                            :uses_bundler,:alert_emails,:url,:git_revision,:rails_env)
    end
    
    def data_bag_item_data
        {
            :id => name,
            :deployment_timestamp => app_timestamp,
            :deployment => configuration,
            :project => project_configuration,
            :customer => customer_configuration,
            :database => database_configuration
        }
    end
    
    def update_data_bag_item
      chef_account_update_data_bag_item(data_bag_item_data)
    end
        
end
