class RemoveRdsSecurityGroupNames < ActiveRecord::Migration
  def up
    remove_column :databases, :security_group_names
  end

  def down
    add_column :databases, :security_group_names, :string, :default => "--- []\n"
  end
end
