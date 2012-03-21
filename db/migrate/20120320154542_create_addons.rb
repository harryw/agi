class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.string :name
      t.text :value

      t.timestamps
    end
  end
end
