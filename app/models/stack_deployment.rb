class StackDeployment < ActiveRecord::Base
  belongs_to :chef_account
  belongs_to :user

  #delegate :chef_account_update_data_bag_item, :to => :dependency, :prefix => true
  #    
  serialize :deployed_data
  #
  ## :update_databag will be moved to an asyncronous state later
  #before_save :description, :save_deployed_data, :update_databag
  before_save :set_initial_status, :save_deployed_data
  
  attr_accessible :description

  def set_initial_status
    self.started_at = Time.now
    self.final_result = 'Pending'
    self.description = app.name if description.blank?
  end
  
  def save_deployed_data
    @chef_account = ChefAccount.find(params[:stack_id])
    self.deployed_data = Dependency.generate_deployment_data(@chef_account)
    self.deployment_timestamp = deploying_time
  end
  
  def deploying_time
    @deploying_time ||= Time.now
  end
end