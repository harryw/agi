class AddAppNameToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :app_name, :string
  end
end
