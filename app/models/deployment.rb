class Deployment < ActiveRecord::Base
    belongs_to :app
    
    delegate :chef_account_update_data_bag_item, :to => :app, :prefix => true
        
    serialize :deployed_data
    
    # :update_databag will be moved to an asyncronous state later
    before_save :set_initial_status, :save_deployed_data, :update_databag
    
    def set_initial_status
      self.started_at = Time.now
      self.final_result = 'Pending'
    end
    
    def save_deployed_data
      self.deployed_data = merged_configuration
    end
   
    def update_databag
      begin
        app_chef_account_update_data_bag_item(merged_configuration)
        self.final_result = 'Success'
        self.opscode_log= 'OK'
      rescue 
        self.opscode_log= $!.message 
        self.final_result = 'Failed'  
      end
      self.completed_at = Time.now  # self is required for assignments
    end
    
    def configuration
      attributes.symbolize_keys.extract!(:force_deploy,:send_email,:task,:run_migrations,
                                                  :migration_command,:deployment_timestamp)
    end
    
    def merged_configuration
      conf = app.generate_deployment_data
      conf[:main].merge!(configuration)
      conf
    end
    
    
end
