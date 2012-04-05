class AddSnapshotIdToDatabases < ActiveRecord::Migration
  def change
    add_column :databases, :snapshot_id, :string
  end
end
