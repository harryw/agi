class RenameUrlToDomainInApps < ActiveRecord::Migration
  def change
    rename_column :apps, :url, :domain
  end
end
