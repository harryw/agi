class DeploymentsController < ApplicationController
  
  before_filter :authenticate_user!
  
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
    end
  end

  # GET /deployments/new
  # GET /deployments/new.json
  def new
    @deployment = @app.deployments.new
    @deployment_data = @app.generate_deployment_data
    
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
        format.html { render action: "new" }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end


  def load_deployment_from_id
      @deployment = @app.deployments.find(params[:id])
  end
  

end
