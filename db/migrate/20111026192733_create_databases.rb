class CreateDatabases < ActiveRecord::Migration
  def change
    create_table :databases do |t|
      t.string :name
      t.string :db_name
      t.string :username
      t.string :password
      t.text :client_cert
      t.string :type
      t.string :instance_class
      t.integer :instance_storage
      t.boolean :multi_az
      t.string :availability_zone
      t.string :engine_version

      t.timestamps
    end
  end
end
