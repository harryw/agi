class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :formal_name
      t.string :homepage
      t.text :description
      t.string :repository
      t.text :repo_private_key

      t.timestamps
    end
  end
end
