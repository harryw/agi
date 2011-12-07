class ChangeTypeDatabaseId < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.remove :database_id
      t.string :database_id
    end
  end
end
