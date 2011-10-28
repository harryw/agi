class RepositoryMisspelledInProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t| 
      t.rename :respository, :repository
    end
  end
end
