class AppsController < ApplicationController
  # GET /apps
  # GET /apps.json
  def index
    @apps = App.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
    @app = App.find(params[:id])
     
    @deployment_status = 
        if !@app.databag_item_timestamp
            "Never Deployed"
        elsif @app.databag_item_timestamp.to_i == @app.app_timestamp.to_i
            "Deploy at: #{@app.app_timestamp}"
        else
            "Undeployed Changes"
        end
        
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.json
  def new
    @app = App.new
    #@ec2_sg_filtered = ec2_sg_filtered
    load_ec2_sg_filtered
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.find(params[:id])
    @ec2_sg_filtered = ec2_sg_filtered
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(params[:app])
    
    # This is not right. I should write a dashboard view that talks to the controllers restfully
    if @app.auto_generate_database
      # when valid? is call, self-generated app attibues are populated
      if @app.valid?
        if generate_database
          @app.save
          redirect_to @app, notice: 'App was successfully created.' 
        end
      else
        render action: "new" 
      end
    else
      if @app.save
        redirect_to @app, notice: 'App was successfully created.' 
      else
        render action: "new" 
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.json
  def update
    @app = App.find(params[:id])

    respond_to do |format|
      if @app.update_attributes(params[:app])
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.json
  def destroy
    @app = App.find(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :ok }
    end
  end
  
  private
    def load_ec2_sg_filtered
      if ec2_sg_filtered.blank?
        @app.errors.add(:ec2_sg_to_authorize, "it failed to load ec2 security groups from agifog, you can specifiy manually")
      end
    end
  
    def ec2_sg_filtered
      @ec2_sg_filtered ||= ComputeSecurityGroup.get(:search, :contains => 'ruby|java').map {|sg| sg['name']} rescue nil
    end
  
    def generate_database
      database_params = {
        :name => @app.name,
        :db_name => @app.name.gsub(/-/,"_"),
        :username => "agi",
        :client_cert => "",
        :db_type => "mysql",
        :instance_class => "db.m1.small",
        :instance_storage => 5,
        :multi_az => false,
        :availability_zone => "us-east-1b",
        :engine_version => "5.5.12",
        :started => false,
        :state => 'stopped',
        :ec2_sg_to_authorize => @app.ec2_sg_to_authorize
      }
     
      @database = Database.new(database_params)
      if @database.save
        @app.database = @database
        return true
      else
        render 'databases/new'
        return false
      end
    end
end
