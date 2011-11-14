class CreateCustomizations < ActiveRecord::Migration
  def change
    create_table :customizations do |t|
      t.string :name
      t.string :location
      t.string :value
      t.boolean :prompt_on_deploy
      t.integer :customizable_id
      t.string :customizable_type

      t.timestamps
    end
  end
end
