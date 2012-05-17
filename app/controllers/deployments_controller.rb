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
    flash[:warning] = db_status
    # If the rds was restored from a snapshot, a few fields have to be modify after becomes available: security_groups, password, size
    # if the user went previously to the /databases#show page the following had been run
    @database_client = @app.database_sync_agi_fields_to_rds unless @app.database_snapshot_id.blank?
    load_deployment_data
    verify_medistrano_pir_exists if Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable
  end


  # POST /deployments
  # POST /deployments.json
  def create
    @deployment = @app.deployments.build(params[:deployment])
    @deployment.user = current_user
    respond_to do |format|
      begin
        if @deployment.save
          format.html { redirect_to [@app,@deployment], notice: "A deployment has been created" }
        else
          load_deployment_data
          format.html { render action: "new" }
        end
      rescue => e
        load_deployment_data
        @deployment.errors.add("base", e.message)
        format.html { render action: "new" }
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
    
    def db_status
      if !@app.database_attached?
        "WARNING: database not attached, please attach a database to this app before deploying"
      elsif !@app.database_started
        "WARNING: database hasn't been started, please start it before deploying"
      elsif !@app.database_ready?
        "WARNING: database is not ready yet, please wait until the rds instance is available"
      end
    end
    
    def verify_medistrano_pir_exists
      if @deployment.app_ec2_sg_to_authorize.blank?
        @enable_merge_iq_with_medistrano_pir_checkbox = false
      else
        begin
          @deployment.get_medistrano_pir # it raise an exception if either the Medistrano PIR doesn't exist or the access is denied
          @enable_merge_iq_with_medistrano_pir_checkbox = true
        rescue => e
          @enable_merge_iq_with_medistrano_pir_checkbox = false
          @error_hint = e.message
        end
      end
    end

end
