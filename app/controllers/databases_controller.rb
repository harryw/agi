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
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @database }
    end
  end

  # GET /databases/1/edit
  def edit
    @database = Database.find(params[:id])
    
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
    @database_conf = Database.find(params[:id])
    
    @database_conf.security_group_names.each {|sg_name| create_rds_security_group(sg_name,@database_conf.ec2_sg_to_authorize) }
    
    rds_attributes = {}
    rds_attributes[:id] = @database_conf.name
    rds_attributes[:engine] = @database_conf.db_type
    rds_attributes[:engine_version] = @database_conf.engine_version
    rds_attributes[:db_name] = @database_conf.db_name
    rds_attributes[:master_username] = @database_conf.username
    rds_attributes[:password] = @database_conf.password
    rds_attributes[:allocated_storage] = @database_conf.instance_storage
    rds_attributes[:multi_az] = @database_conf.multi_az
    # Requesting a specific availability zone is not valid for Multi-AZ instances
    rds_attributes[:availability_zone] = @database_conf.availability_zone unless @database_conf.multi_az
    rds_attributes[:flavor_id] = @database_conf.instance_class
    rds_attributes[:security_group_names] = @database_conf.security_group_names
    
    @database = RdsServer.new(rds_attributes)
    @prop_url = [:admin, @database]
    respond_to do |format|
      if @database.save
        @database_conf.started = true
        @database_conf.state = 'creating'
        @database_conf.save
        format.html { redirect_to @database_conf, notice: 'RdsServer was successfully created.' }
        format.json { render json: @database_conf, status: :created, location: @database }
      else
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
  
    def create_rds_security_group(security_group_name,ec2_sg_to_authorize)
      # verify if the security group doesn't exist yet
      begin
        RdsSecurityGroup.find(security_group_name) # if it doesn't exists it throws an exception
        return nil
      rescue
        # create it with the proper permisions
        sg = RdsSecurityGroup.create(:id => security_group_name,:description => 'generated by agi')
        # authorize
        unless ec2_sg_to_authorize.blank?
           authorize_ec2 = {
              :ec2name => ec2_sg_to_authorize,
              :ec2owner => sg.owner_id 
            }.to_json
          puts "Authorizating #{ec2_sg_to_authorize} #{sg.owner_id }"
          sg.put(:authorize, nil,authorize_ec2)
        else
          puts "Fail #{ec2_sg_to_authorize}"
        end
      end

    end
end
