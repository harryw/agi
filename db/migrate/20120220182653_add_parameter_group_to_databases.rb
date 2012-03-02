class AddParameterGroupToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :parameter_group, :string, :default => "default.mysql5.5"
  end
end
