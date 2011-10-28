class ChefAccountBelongsToApp < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.belongs_to :chef_account
    end
  end
end
