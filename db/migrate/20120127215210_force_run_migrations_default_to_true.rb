class ForceRunMigrationsDefaultToTrue < ActiveRecord::Migration
  def up
    change_column_default :deployments, :run_migrations, true
  end
  
  def down
    change_column_default :deployments, :run_migrations, false
  end
    
end
