class LinkCustomerAndProjectFromApp < ActiveRecord::Migration
    def change
        change_table :apps do |t|
         t.remove :customer_link
         t.belongs_to :customer
         t.remove :project_link
         t.belongs_to :project
        end
    end
end
