class Database < ActiveRecord::Base
  
  has_one :app
  
  validates_presence_of :name
  
  after_save :update_apps
  
  
  def update_apps
    app.touch if app
  end
  
   def configuration
       attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:type,:hostname)
   end
end
