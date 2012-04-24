class Dependency < ActiveRecord::Base
  attr_accessible :app_id, :backend_id, :frontend_id
  belongs_to :app
  belongs_to :backend, :class_name => "App", :foreign_key => "backend_id"
  belongs_to :frontend, :class_name => "App", :foreign_key => "frontend_id"
  belongs_to :chef_account # it really simplifies the filtering
  has_many :permits
  before_create :populate_chef_account
  after_create :create_frontend_dependency, :if => :backend_id
  after_create :create_backend_dependency, :if => :frontend_id
  
  validates_presence_of :app_id
  
  scope :with_backends, where("backend_id IS NOT NULL")
  scope :with_frontends, where("frontend_id IS NOT NULL")
  
  delegate :name, :update_data_bag_item, :to => :chef_account, :prefix => true, :allow_nil => true
  
  def create_frontend_dependency
    backend.frontends << app unless backend.frontends.include?(app)
  end
  
  def create_backend_dependency
    frontend.backends << app unless frontend.backends.include?(app)
  end
  
  
  private
  
  def self.get_all_frontends
    #self.all.map {|d| d.app if d.backend }.compact
    includes(:backend).includes(:app).map {|d| d.app if d.backend }.compact.uniq
  end
  
  def populate_chef_account
    self.chef_account_id = app.chef_account_id
  end
end