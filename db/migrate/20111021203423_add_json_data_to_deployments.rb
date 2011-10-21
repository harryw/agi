class AddJsonDataToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :json_data, :text
  end
end
