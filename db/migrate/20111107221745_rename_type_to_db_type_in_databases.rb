class RenameTypeToDbTypeInDatabases < ActiveRecord::Migration
  def change
     change_table :databases do |t|
          t.rename :type, :db_type
      end
  end
end
