class AddStackDeployments < ActiveRecord::Migration
  def change
    create_table :stacks_deployments do |t|
      t.datetime :started_at
      t.datetime :completed_at
      t.datetime :deployment_timestamp
      t.text     :deployed_data
      t.string   :final_result
      t.string   :opscode_result
      t.text     :opscode_log
      t.string   :description
      t.integer  :user_id
    end
  end
  
end
