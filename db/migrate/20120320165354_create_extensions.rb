class CreateExtensions < ActiveRecord::Migration
  def change
    create_table :extensions do |t|
      t.integer :app_id
      t.integer :addon_id

      t.timestamps
    end
  end
end
