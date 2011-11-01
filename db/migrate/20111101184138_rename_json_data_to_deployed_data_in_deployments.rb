class RenameJsonDataToDeployedDataInDeployments < ActiveRecord::Migration
  def change
    change_table :deployments do |t|
      t.rename :json_data, :deployed_data
    end
  end
end
