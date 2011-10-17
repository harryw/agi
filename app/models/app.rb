class App < ActiveRecord::Base
    
    
    def databag_item_timestamp
        false
        #To do
        #pry(main)> App.first.updated_at
        #=> Fri, 14 Oct 2011 19:06:10 UTC +00:00
        #pry(main)> App.first.updated_at.class
        #=> ActiveSupport::TimeWithZone
        #pry(main)> App.first.updated_at.to_i
        #
    end
    
    def app_timestamp
        self.updated_at
    end
end
