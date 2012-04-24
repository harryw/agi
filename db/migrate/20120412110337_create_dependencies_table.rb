class CreateDependenciesTable < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
       t.integer :app_id
       t.integer :backend_id
       t.integer :frontend_id
       t.integer :chef_account_id
    end
    
    create_table :permits do |t|
      t.integer :dependency_id
      t.string :port # so you can specify a range
      t.string :security_group
    end
  end
end
