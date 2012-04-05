class DatabasesController < ApplicationController
  # GET /databases
  # GET /databases.json
  def index
    @databases = Database.all
    @databases.each do |database|
      database.refresh_database_state
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @databases }
    end
  end

  # GET /databases/1
  # GET /databases/1.json
  def show
    @database = Database.find(params[:id])
    @database.refresh_database_state

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @database }
    end
  end

  # GET /databases/new
  # GET /databases/new.json
  def new
    @database = Database.new
    load_parameter_groups
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @database }
    end
  end

  # GET /databases/1/edit
  def edit
    @database = Database.find(params[:id])
    load_parameter_groups
  end

  # POST /databases
  # POST /databases.json
  def create
    @database = Database.new(params[:database])
    @database.started = false
    @database.state = 'stopped'
    
    respond_to do |format|
      if @database.save
        format.html { redirect_to @database, notice: 'Database was successfully created.' }
        format.json { render json: @database, status: :created, location: @database }
      else
        format.html { render action: "new" }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /databases/1
  # PUT /databases/1.json
  def update
    @database = Database.find(params[:id])
    load_parameter_groups
    
    respond_to do |format|
      if @database.update_attributes(params[:database])
        format.html { redirect_to @database, notice: 'Database was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /databases/1
  # DELETE /databases/1.json
  def destroy
    @database = Database.find(params[:id])
    if @database.started
      @database_client = RdsServer.find(@database.name)
      @database_client.destroy
    end
    @database.destroy

    respond_to do |format|
      format.html { redirect_to databases_url }
      format.json { head :ok }
    end
  end
  
  def start
    @database = Database.find(params[:id])
    
    rds_attributes = {}
    rds_attributes[:id] = @database.name
    rds_attributes[:engine] = @database.db_type
    rds_attributes[:engine_version] = @database.engine_version
    rds_attributes[:db_name] = @database.db_name
    rds_attributes[:master_username] = @database.username
    rds_attributes[:password] = @database.password
    rds_attributes[:allocated_storage] = @database.instance_storage
    rds_attributes[:multi_az] = @database.multi_az
    # Requesting a specific availability zone is not valid for Multi-AZ instances
    rds_attributes[:availability_zone] = @database.availability_zone unless @database.multi_az
    rds_attributes[:flavor_id] = @database.instance_class
    rds_attributes[:security_group_names] = [@database.security_group_name]
    rds_attributes[:parameter_group_name] = @database.parameter_group
    rds_attributes[:snapshot_id] = @database.snapshot_id
    
    rds_attributes.reject!{|k,v| v.blank? }
    
    @rds_sec_groups = create_rds_security_group(@database.security_group_name,@database.ec2_sg_to_authorize)
    # this is an active resource workaround
    #rds_sec_groups_valid = @rds_sec_groups.class == Net::HTTPOK ? true : @rds_sec_groups.valid?
    rds_sec_groups_valid = @rds_sec_groups.class == Net::HTTPOK ? true : @rds_sec_groups
                            
    
    @rds_server = RdsServer.new(rds_attributes)
    respond_to do |format|
      if rds_sec_groups_valid and @rds_server.save
        @database.started = true
        @database.state = 'creating'
        @database.save
        format.html { redirect_to @database, notice: 'RdsServer was successfully created.' }
        format.json { render json: @database, status: :created, location: @database }
      else
        unless rds_sec_groups_valid
          transform_active_resource_erros_to_database(@rds_sec_groups,@database)
        else
          transform_active_resource_erros_to_database(@rds_server,@database)
        end
        format.html { render action: "new" }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def stop
    @database = Database.find(params[:id])
    begin
      @database_client = RdsServer.find(@database.name)
      @database_client.destroy
      @database.state = 'Terminated'
      @database.started = false
    rescue
      @database.state = 'missing'
    end
    @database.hostname = nil
    @database.save
    
    respond_to do |format|
      format.html { redirect_to databases_url }
      format.json { head :ok }
    end
  end
  

  
  private
    def load_parameter_groups
      if parameter_groups.blank?
        @database.errors.add(:parameter_group, "it failed to load rds parameter groups from agifog, using the the default one")
      end
    end
    
          
    # RdsServer gets the raw errors from aws, this method try to parse those errors and assaign it to a specifc database field,
    # if not just, add the error to base.
    def transform_active_resource_erros_to_database(active_resource,database)
      # this hash, maps aws errors to specific agi database fields 
      errors_map = {
          "DBInstanceAlreadyExists" => :name,
          "DBInstanceIdentifier" => :name,
          "DBSecurityGroupName" => :security_group_name,
          "availability zone" => :availability_zone,
          "boolean must follow" => :multi_az,
          "master_username" => :username,
          "master user name" => :username,
          "password" => :password,
          "MasterUserPassword" => :password,
          "DBName" => :db_name,
          "DB engine" => :db_type,
          "Cannot find version" => :engine_version,
          "storage size" => :instance_storage,
          "DB instance" => :instance_class,
          "DBParameterGroup" => :parameter_group,
          "DBSecurityGroup" => :security_group_name
      }
      active_resource.errors.messages.each_value do |aws_raw_error|
        field_message = errors_map.select { |aws_error_pattern,db_field| aws_raw_error.join =~ /#{aws_error_pattern}/ }
        if field_message.blank?
          database.errors.add(:base,aws_raw_error)
        else
          field_message.each_value { |db_field| database.errors.add(db_field,aws_raw_error) }
        end
      end
    end
  
    def parameter_groups
      @parameter_groups ||= RdsParameterGroup.all.map(&:id) rescue nil
    end
  
    def create_rds_security_group(security_group_name,ec2_sg_to_authorize)
      # verify if the security group doesn't exist yet
      begin
        @sg = RdsSecurityGroup.find(security_group_name) # if it doesn't exist throws an exception
        return @sg #if exists, we can assume that 
      rescue
      end
      
      begin
        # create it with the proper permisions
        @sg = RdsSecurityGroup.new(:id => security_group_name,:description => 'generated by agi')
        return @sg unless @sg.save
        # authorize
        unless ec2_sg_to_authorize.blank?
           authorize_ec2 = {
              :ec2name => ec2_sg_to_authorize,
              :ec2owner => @sg.owner_id 
            }.to_json
          Rails.logger.info "Authorizating #{ec2_sg_to_authorize} #{@sg.owner_id }"
          # damn buggy active resource!! the put line, returns "#<Net::HTTPOK 200 OK readbody=true>"
          # @sg.class => Net::HTTPOK
          # @sg.code => "200"
          # if it fails, it returns an active resource object
          return @sg.put(:authorize, nil,authorize_ec2)
        else
          Rails.logger.info "#{ec2_sg_to_authorize} is empty"
        end
      rescue
         return(@sg)
      end 
    end
    

end
