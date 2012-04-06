class Database < ActiveRecord::Base
  serialize :security_group_names
  
  has_one :app
  after_initialize :default_values
  before_validation :set_default_rds_attributes
  attr_accessible :name, :db_name, :username, :password, :client_cert, :db_type, :instance_class, :instance_storage, :multi_az, :availability_zone, 
  :engine_version, :updated_at, :state, :started, :hostname, :security_group_names, :ec2_sg_to_authorize, :parameter_group, :snapshot_id
  
  
#  http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  validates_presence_of :db_name, :username, :password, :instance_class, :engine_version, :db_type, :instance_storage, :parameter_group, :unless => :snapshot_id
  validates_presence_of :name
  validates_presence_of :availability_zone, :unless => :multi_az
  validates_uniqueness_of :name
  validates_numericality_of :instance_storage, :greater_than_or_equal_to => 5, :less_than_or_equal_to => 1024, :unless => :snapshot_id
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
  validates_format_of :db_name, :with => /\A[A-Za-z0-9_-]+\z/,  :message => "Please use only alphanumeric characters and hypens", :unless => :snapshot_id
  
  
  # Constraints:
  # 
  # Must be 1 to 16 alphanumeric characters.
  # First character must be a letter.
  # Cannot be a reserved word for the chosen database engine.
  validates_format_of :username, :with => /\A[A-Za-z0-9-]+\z/,  :message => "Please use only alphanumeric characters", :unless => :snapshot_id
  
  # Constraints: Cannot contain more than 41 alphanumeric characters.
  validates_format_of :password, :with => /\A[A-Za-z0-9-]+\z/,  :message => "Please use only alphanumeric characters", :unless => :snapshot_id
  
  after_save :update_apps
  
  def update_apps
    app.touch if app
  end
  
  def configuration
      attributes.symbolize_keys.extract!(:name,:db_name,:username,:password,:db_type,:hostname)
  end
  
  def set_default_rds_attributes
    self.password = SecureRandom.hex(16) if password.blank?
    #self.security_group_names = [ self.name ]
    self.security_group_name ||= self.name
  end
  
  def ready?
    refresh_database_state
    self.state == 'available'
  end
  
  def refresh_database_state
    if started and state != 'available' or sg_out_of_sync
      begin
        @database_client = RdsServer.find(self.name)
        self.state = @database_client.state
        self.hostname = @database_client.endpoint.attributes["Address"]
        # If the rds was created throught a snapshot, it will come up with the default security group
        if @database_client.db_security_groups.select { |sg| sg.attributes['DBSecurityGroupName'] == self.security_group_name }.blank?
          self.sg_out_of_sync = true
        else
          self.sg_out_of_sync = false
        end
      rescue
        self.started = false
        self.state = 'missing'
        self.hostname = nil
      end
      
      self.save 
    end
    
  end
  
  def mysql_command
    "mysql -u #{username} -p#{password} -h #{hostname} #{db_name}"
  end
  
  private
  
    def default_values
      self.engine_version ||= "5.5.12"
      self.db_type ||= "mysql"
      self.instance_class ||= "db.m1.small"
      self.availability_zone ||= 'us-east-1c'
    end
  
end

