class DatabasesController < ApplicationController
  # GET /databases
  # GET /databases.json
  def index
    @databases = Database.all
    @databases.each do |database|
      if database.started and database.state != 'available'
        begin
          database_client = DatabaseClient.find(database.name)
          database.state = database_client.state
          database.hostname = database_client.endpoint.attributes["Address"]
          database.save
        rescue
          database.started = false
          database.state = 'missing'
          database.hostname = nil
          database.save
        end
      end
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
    if @database.started and @database.state != 'available'
      begin
        @database_client = DatabaseClient.find(@database.name)
        @database.state = @database_client.state
        @database.hostname = @database_client.endpoint.attributes["Address"]
      rescue
        @database.started = false
        @database.state = 'missing'
        @database.hostname = nil
      end
      @database.save
      
    end
    

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
      @database_client = DatabaseClient.find(@database.name)
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
    
    @database = DatabaseClient.new(rds_attributes)
    respond_to do |format|
      if @database.save
        @database_conf.started = true
        @database_conf.state = 'creating'
        @database_conf.save
        format.html { redirect_to @database_conf, notice: 'DatabaseClient was successfully created.' }
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
      @database_client = DatabaseClient.find(@database.name)
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
end
