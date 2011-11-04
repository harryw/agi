class AddFinalResultOpscodeResultsOpscodeLogToDeployments < ActiveRecord::Migration
  def change
    change_table :deployments do |t|
      t.string :final_result
      t.string :opscode_result
      t.text :opscode_log
      t.remove :result_log
      t.remove :description
      t.string :description
    end
  end
end
