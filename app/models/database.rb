class Database < ActiveRecord::Base
  validates_presence_of :name
  
  
   def configuration
       attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:type,:hostname)
   end
end
