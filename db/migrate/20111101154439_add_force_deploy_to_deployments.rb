class AddForceDeployToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :force_deploy, :boolean, :default => false
  end
end
