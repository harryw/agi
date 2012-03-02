class AddMedistranoCloudNameToApps < ActiveRecord::Migration
  def change
    add_column :apps, :ec2_sg_to_authorize, :string, :default => ""
  end
end
