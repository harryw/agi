class AddClientNameToChefAccounts < ActiveRecord::Migration
  def change
    add_column :chef_accounts, :client_name, :text
  end
end
