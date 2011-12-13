class Database < ActiveRecord::Base
  
  has_one :app
  
  validates_presence_of :name, :db_name, :username, :password, :instance_class, :instance_storage, :engine_version, :db_type
  validates_presence_of :availability_zone, :unless => :multi_az
  
  after_save :update_apps
  
  def update_apps
    app.touch if app
  end
  
  def configuration
      attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:db_type,:hostname)
  end
end

