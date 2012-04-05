class AddSgOutOfSyncToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :sg_out_of_sync, :boolean, :default => false
  end
end
