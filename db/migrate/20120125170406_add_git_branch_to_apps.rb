class AddGitBranchToApps < ActiveRecord::Migration
  def change
    add_column :apps, :git_branch, :string
  end
end
