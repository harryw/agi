class AddStateToDatabase < ActiveRecord::Migration
  def change
    add_column :databases, :state, :string
    add_column :databases, :started, :boolean
  end
end
