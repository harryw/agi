class RemoveDefaultLocalhostInDatabaseModel < ActiveRecord::Migration
  def change
    remove_column :databases, :hostname
    add_column :databases, :hostname, :string
  end
end
