class RenameFormalNameFromCustomer < ActiveRecord::Migration
    def change
        change_table :customers do |t|
            t.rename :name, :name_tag
            t.rename :formal_name, :name
        end
    end
end
