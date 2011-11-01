class AddHostnameToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :hostname, :string, :default => 'localhost'
  end
end
