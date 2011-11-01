class ChangeMultiTenantUsesBundlerToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.remove :multi_tenant
      t.boolean :multi_tenant
      t.remove :uses_bundler
      t.boolean :uses_bundler, :default => true
      t.remove :chef_account_link
    end
  end
end
