class AddPlatformToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :platform, :string
  end
end
