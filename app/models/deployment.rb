class Deployment < ActiveRecord::Base
    belongs_to :app
    
    delegate :update_data_bag_item, :to => :app, :prefix => true
    
    before_save :app_update_data_bag_item
    
end
