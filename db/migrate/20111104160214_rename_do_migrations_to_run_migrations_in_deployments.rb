class RenameDoMigrationsToRunMigrationsInDeployments < ActiveRecord::Migration
  def change
    change_table :deployments do |t|
      t.rename :do_migrations, :run_migrations
    end
  end
end
