class StackDeployment < ActiveRecord::Base
  belongs_to :chef_account
  belongs_to :user

  #delegate :chef_account_update_data_bag_item, :to => :dependency, :prefix => true
  #    
  serialize :deployed_data
  #
  ## :update_databag will be moved to an asyncronous state later
  #before_save :description, :save_deployed_data, :update_databag
  before_save :set_initial_status, :save_deployed_data, :update_databag
  
  attr_accessible :description
  
  delegate :name, :update_data_bag_item, :to => :chef_account, :prefix => true, :allow_nil => true
  

private
    def set_initial_status
      self.started_at = Time.now
      self.final_result = 'Pending'
      self.description = chef_account.name if description.blank?
    end
    
    def save_deployed_data
      self.deployed_data = stack_configuration
      self.deployment_timestamp = deploying_time
    end
    
    def deploying_time
      @deploying_time ||= Time.now
    end
    
    def stack_configuration
      stack_conf = Dependency.generate_deployment_data(chef_account)
      {:id => 'stacks', :main => stack_conf}
    end
    
    def data_bag_name
      'agi_stack'
    end
    
    def update_databag
      begin
        chef_account_update_data_bag_item(stack_configuration,data_bag_name)
        self.final_result = 'Success'
        self.opscode_log= 'OK'
      rescue 
        self.opscode_log= $!.message 
        self.final_result = 'Failed'  
      end
      self.completed_at = Time.now  # self is required for assignments
    end
end