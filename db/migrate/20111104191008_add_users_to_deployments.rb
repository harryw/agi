class AddUsersToDeployments < ActiveRecord::Migration
  def change
    change_table :deployments do |t|
      t.belongs_to :user
    end
  end
end
