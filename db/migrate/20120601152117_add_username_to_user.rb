class AddUsernameToUser < ActiveRecord::Migration
  def up
    add_column :users, :username, :string, { :after => :id, :null => false }
    # Delete all users wihout mdsol addresses - they are not useful now
    (User.all.select {|u| u.email !~ /@mdsol.com$/}).each {|u| u.destroy }
    # Copy the username from the email
    User.all.each do |user|
      user.username = user.email.scan(/\A[^@]+/).first
      # iMedidata insists on a 5-character minimum for username - fix exceptions
      user.username = 'paulm' if user.email == 'pmin@mdsol.com' # Paul Min
      user.save!
    end
  end

  def down
    remove_column :users, :username
  end

end
