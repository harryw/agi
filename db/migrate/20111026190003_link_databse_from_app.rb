class LinkDatabseFromApp < ActiveRecord::Migration
  def change
      change_table :apps do |t|
          t.remove :database_link
          t.belongs_to :database
      end
  end
end
