class AddSecurityGroupNameToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :security_group_name, :string
  end
end
