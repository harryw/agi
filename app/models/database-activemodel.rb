#class Database < ActiveRecord::Base
#  
#  has_one :app
#  
#  validates_presence_of :name
#  
#  after_save :update_apps
#  
#  
#  def update_apps
#    app.touch if app
#  end
#  
#   def configuration
#       attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:db_type,:hostname)
#   end
#end
#
require '/Users/restebanez/agidb/client'

class Database < InstanceDB
  self.base_uri = "http://localhost:3000"
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods
  
  #has_one :app
  #after_save :update_apps
  
  attr_accessor :name, :db_name, :username, :password, :db_type, :hostname, :client_cert, :instance_class, :instance_storage, :multi_az, :availability_zone, :engine_version
  validates_presence_of :name
  
  #@attributes.each {|k, v| send("#{k}=", v)} #p155 service-oriented

  def initialize(attributes = {}) 
    attributes.each do |name, value|
      send("#{name}=", value) 
    end
  end
  
  def self.attributes(*names) 
    attr_accessor *names
  end
  
  def persisted? 
    false
  end
  
  def configuration
      attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:db_type,:hostname)
  end
  
  def update_apps
    app.touch if app
  end                                                                                                          
end