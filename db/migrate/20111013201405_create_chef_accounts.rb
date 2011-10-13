class CreateChefAccounts < ActiveRecord::Migration
  def change
    create_table :chef_accounts do |t|
      t.string :name
      t.string :formal_name
      t.text :validator_key
      t.text :client_key
      t.text :databag_key
      t.string :api_url

      t.timestamps
    end
  end
end
