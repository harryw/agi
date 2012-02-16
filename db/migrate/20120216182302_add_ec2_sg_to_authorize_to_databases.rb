class AddEc2SgToAuthorizeToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :ec2_sg_to_authorize, :string, :default => ""
  end
end
