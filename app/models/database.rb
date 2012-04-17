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
    if started and state != 'available'
      begin
        database_client(force=true)
        self.state = database_client.state
        self.hostname = database_client.endpoint.attributes["Address"]
        populate_empty_fields unless snapshot_id.blank?
      rescue
        self.started = false
        self.state = 'missing'
        self.hostname = nil
      end
      self.save
    end
  end
  
  # After starting a rds instance out of a snapshot, some fields have to be modified
  def sync_agi_fields_to_rds
    # you can only modify when the rds instances is available
    if state == 'available' and any_field_out_of_sync?
      rds_server = {
        :password => password,
        :allocated_storage => instance_storage,
        :multi_az => multi_az,
        :flavor_id => instance_class,
        :security_group_names => [self.security_group_name],
#        :security_group_names => ['dont-exist'], # this will produce a 422 from agifog
      }.reject!{|k,v| v.blank? }
      begin
        if database_client.update_attributes(rds_server)
          self.state = 'modifying'
        else
          self.state = 'error syncing'
          self.save
        end
      rescue
        database_client.errors.add(:base, "It failed to update the attributes. #{rds_server.inspect}")
        self.state = 'error syncing'
        self.save
      end
      
      database_client
    end
  end
  

  

  
  def mysql_command
    "mysql -u #{username} -p#{password} -h #{hostname} #{db_name}"
  end
  
  private
    def database_client(force=false)
      begin
        if force
          @database_client = RdsServer.find(self.name)
        else
          @database_client ||= RdsServer.find(self.name)
        end
      rescue
        @database_client = nil
      end
      @database_client
    end
    
    def any_field_out_of_sync?
      # If the rds was created throught a snapshot, it will come up with the default security group
      if database_client.db_security_groups.select { |sg| sg.attributes['DBSecurityGroupName'] == self.security_group_name }.blank?
        return true
      else
        return false
      end
    end
  
    # This method only applies for restore db instance from db snapshot
    def populate_empty_fields
      self.instance_storage ||= database_client.allocated_storage
      self.instance_class ||= database_client.flavor_id
      self.multi_az ||= database_client.multi_az
      self.availability_zone ||= database_client.availability_zone
      # The following fields can't be modify
      self.username = database_client.master_username
      self.db_type = database_client.engine
      # The following fields aren't modify by agi yet
      self.engine_version = database_client.engine_version
      self.db_name = database_client.db_name
      self.parameter_group = database_client.db_parameter_groups.first.attributes["DBParameterGroupName"]
    end
  
    def default_values
      self.engine_version ||= "5.5.12"
      self.db_type ||= "mysql"
      self.instance_class ||= "db.m1.small"
      self.availability_zone ||= 'us-east-1c'
    end
  
end

