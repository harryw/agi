class AddS3IqUrlToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :s3_url_iq, :string, :default => ""
    add_column :deployments, :deployed_time, :datetime
  end
end
