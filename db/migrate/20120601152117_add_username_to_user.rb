class AddUsernameToUser < ActiveRecord::Migration
  def up
    add_column :users, :username, :string, { :after => :id, :null => false }
  end

  def down
    remove_column :users, :username
  end

end
