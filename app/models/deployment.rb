class Deployment < ActiveRecord::Base
    belongs_to :app
    
    #delegate :update_data_bag_item, :to => :app, :prefix => true
    delegate :chef_account_update_data_bag_item, :to => :app, :prefix => true
    
    #before_save :app_update_data_bag_item
    
    serialize :deployed_data
    before_save :update_databag
    
#    def save_deployed_data
#      deployed_data = merged_configuration
#    end

    
    def update_databag
      app_chef_account_update_data_bag_item(merged_configuration)
    end
    
    def configuration
      attributes.symbolize_keys.extract!(:force_deploy,:send_email,:task,:do_migrations,
                                                  :migration_command,:deployment_timestamp)
    end
    
    def merged_configuration
      app.generate_deployment_data.merge(:extra => configuration)
    end
    
end
