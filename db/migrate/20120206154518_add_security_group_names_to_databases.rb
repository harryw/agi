class AddSecurityGroupNamesToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :security_group_names, :string, :default => "--- []\n"
  end
end
