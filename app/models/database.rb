class Database < ActiveRecord::Base
  
  has_one :app
  before_validation :set_default_rds_attributes
  
#  http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  validates_presence_of :name, :db_name, :username, :password, :instance_class, :engine_version, :db_type, :instance_storage
  validates_presence_of :availability_zone, :unless => :multi_az
  validates_uniqueness_of :name
  validates_numericality_of :instance_storage, :greater_than_or_equal_to => 5, :less_than_or_equal_to => 1024
  #  Constraints:
  #
  #  Must contain from 1 to 63 alphanumeric characters or hyphens.
  #  First character must be a letter.
  #  Cannot end with a hyphen or contain two consecutive hyphens.
  validates_format_of :name, :with => /\A[a-z0-9-]+\z/,  :message => "Please use only lowercase letters, numbers and hyphens"
  
  # Constraints:
  # 
  # Must contain 1 to 64 alphanumeric characters
  # Cannot be a word reserved by the specified database engine
  validates_format_of :db_name, :with => /\A[A-Za-z0-9-]+\z/,  :message => "Please use only alphanumeric characters"
  
  
  # Constraints:
  # 
  # Must be 1 to 16 alphanumeric characters.
  # First character must be a letter.
  # Cannot be a reserved word for the chosen database engine.
  validates_format_of :username, :with => /\A[A-Za-z0-9-]+\z/,  :message => "Please use only alphanumeric characters"
  
  # Constraints: Cannot contain more than 41 alphanumeric characters.
  validates_format_of :password, :with => /\A[A-Za-z0-9-]+\z/,  :message => "Please use only alphanumeric characters"
  
  after_save :update_apps
  
  def update_apps
    app.touch if app
  end
  
  def configuration
      attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:db_type,:hostname)
  end
  
  def set_default_rds_attributes
    self.password = SecureRandom.hex(16) if password.blank?
  end
  
  def ready?
    refresh_database_state
    self.state == 'available'
  end
  
  def refresh_database_state
    if started and state != 'available'
      begin
        database_client = DatabaseClient.find(self.name)
        self.state = database_client.state
        self.hostname = database_client.endpoint.attributes["Address"]
      rescue
        self.started = false
        self.state = 'missing'
        self.hostname = nil
      end
      self.save 
    end
  end
  
end

