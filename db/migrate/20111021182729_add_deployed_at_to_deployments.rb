class AddDeployedAtToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :deployment_timestamp, :datetime
  end
end
