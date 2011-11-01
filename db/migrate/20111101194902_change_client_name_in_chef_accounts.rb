class ChangeClientNameInChefAccounts < ActiveRecord::Migration
    def change
      change_table :chef_accounts do |t|
        t.remove :client_name
        t.string :client_name
      end
    end
end
