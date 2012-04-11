class DeploymentsController < ApplicationController
  
  before_filter :load_app
  before_filter :load_deployment_from_id, :only => :show

  # GET /deployments
  # GET /deployments.json
  def index
    @deployments = @app.deployments

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @deployments }
    end
  end

  # GET /deployments/1
  # GET /deployments/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deployment }
      format.pdf do
            pdf = IqDeployment.new(@deployment)
            send_data pdf.render, filename: "pir_#{@app.name}",
                                  type: "application/pdf",
                                  disposition: "inline"
      end
    end
  end

  # GET /deployments/new
  # GET /deployments/new.json
  def new
    @deployment = @app.deployments.new
    flash[:warning]= if !@app.database_attached?
      "WARNING: database not attached, please attach a database to this app before deploying"
    elsif !@app.database_started
      "WARNING: database hasn't been started, please start it before deploying"
    elsif !@app.database_ready?
      "WARNING: database is not ready yet, please wait until the rds instance is available"
    end
    # If the rds was restored from a snapshot, a few fields have to be modify after becomes available: security_groups, password, size
    # if the user went previously to the /databases#show page the following had been run
    @app.database_sync_agi_fields_to_rds unless @app.database_snapshot_id.blank?
    
    load_deployment_data
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deployment }
    end
  end


  # POST /deployments
  # POST /deployments.json
  def create
    @deployment = @app.deployments.build(params[:deployment])
    @deployment.user = current_user
    respond_to do |format|
      if @deployment.save
        format.html { redirect_to [@app,@deployment], notice: "A deployment has been created" }
        format.json { render json: @deployment, status: :created, location: @deployment }
      else
        load_deployment_data
        format.html { render action: "new" }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end


  def load_deployment_from_id
      @deployment = @app.deployments.find(params[:id])
  end
  
  private
  
    def load_deployment_data
      @deployment_data = @app.generate_deployment_data
    end

end
