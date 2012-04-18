class Dependency < ActiveRecord::Base
  attr_accessible :app_id, :backend_id, :frontend_id
  belongs_to :app
  belongs_to :backend, :class_name => "App", :foreign_key => "backend_id"
  belongs_to :frontend, :class_name => "App", :foreign_key => "frontend_id"
  has_many :permits
  after_create :create_frontend_dependency, :if => :backend_id
  after_create :create_backend_dependency, :if => :frontend_id
  
  validates_presence_of :app_id
  
  scope :with_backends, where("backend_id IS NOT NULL")
  scope :with_frontends, where("frontend_id IS NOT NULL")
  
  def create_frontend_dependency
    backend.frontends << app unless backend.frontends.include?(app)
  end
  
  def create_backend_dependency
    frontend.backends << app unless frontend.backends.include?(app)
  end
end