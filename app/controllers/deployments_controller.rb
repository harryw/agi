class DeploymentsController < ApplicationController
    
  before_filter :load_app
  before_filter :load_deployment_from_id, :only => [ :show, :edit, :update, :destroy ]
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

  # GET /deployments/1/edit
  def edit
  end

  # POST /deployments
  # POST /deployments.json
  def create
    @deployment = @app.deployments.build(params[:deployment])
    # By this time, we'll have the full deployment data, including every "prompt on deploy"
    # @deployment.create_or_update_databag(json_data), this can be done with a before_save callback
    respond_to do |format|
      if @deployment.save
        format.html { redirect_to [@app,@deployment], notice: "App has been deployed successfully" }
        format.json { render json: @deployment, status: :created, location: @deployment }
      else
        format.html { render action: "new" }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /deployments/1
  # PUT /deployments/1.json
  def update

    respond_to do |format|
      if @deployment.update_attributes(params[:deployment])
        format.html { redirect_to @deployment, notice: 'Deployment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @deployment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deployments/1
  # DELETE /deployments/1.json
  def destroy
    @deployment.destroy

    respond_to do |format|
      format.html { redirect_to deployments_url }
      format.json { head :ok }
    end
  end
  
  def load_deployment_from_id
      @deployment = @app.deployments.find(params[:id])
  end
end
