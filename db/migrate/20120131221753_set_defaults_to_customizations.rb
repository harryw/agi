class SetDefaultsToCustomizations < ActiveRecord::Migration
  def up
    change_column_default :customizations, :prompt_on_deploy, false
    change_column_default :customizations, :location, ""
  end
  
  def down
    change_column_default :customizations, :prompt_on_deploy, nil
    change_column_default :customizations, :location, nil
  end
end
