class Admin::Rds::SecurityGroupsController < ApplicationController
  # GET /security_groups
  # GET /security_groups.json
  def index
    @security_groups = RdsSecurityGroup.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @security_groups }
    end
  end

  # GET /security_groups/1
  # GET /security_groups/1.json
  def show
    @security_group = RdsSecurityGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @security_group }
    end
  end

  # GET /security_groups/new
  # GET /security_groups/new.json
  def new
    @security_group = RdsSecurityGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @security_group }
    end
  end

  # GET /security_groups/1/edit
  def edit
    @security_group = RdsSecurityGroup.find(params[:id])
  end

  # POST /security_groups
  # POST /security_groups.json
  def create
    @security_group = RdsSecurityGroup.new(params[:rds_security_group])

    respond_to do |format|
      if @security_group.save
        format.html { redirect_to [:admin, @security_group], notice: 'RdsSecurityGroup was successfully created.' }
        format.json { render json: [:admin, @security_group], status: :created, location: [:admin, @security_group] }
      else
        format.html { render action: "new" }
        format.json { render json: @security_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /security_groups/1
  # PUT /security_groups/1.json
  def update
    @security_group = RdsSecurityGroup.find(params[:id])

    respond_to do |format|
      if @security_group.update_attributes(params[:rds_security_group])
        format.html { redirect_to [:admin, @security_group], notice: 'RdsSecurityGroup was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @security_group.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def revoke
    @security_group = RdsSecurityGroup.find(params[:id])
    
    respond_to do |format|
      begin
        @security_group.put(:revoke, nil,params[:rds_security_group].to_json)
        format.html { redirect_to [:admin, @security_group], notice: 'RdsSecurityGroup was revoked.' }
        format.json { head :ok }
      rescue => e
        format.html { flash[:alert] = pretty_error(e.message) ;render action: "show" }
        format.json { render json: @security_group.errors, status: :unprocessable_entity }
      end
    end      
  end
  
  def authorize
    @security_group = RdsSecurityGroup.find(params[:id])
    
    respond_to do |format|
      begin
        @security_group.put(:authorize, nil,params[:rds_security_group].to_json)
        format.html { redirect_to [:admin, @security_group], notice: 'RdsSecurityGroup was authorized.' }
        format.json { head :ok }
      rescue => e
        format.html { flash[:alert] = pretty_error(e.message) ;render action: "show" }
        format.json { render json: @security_group.errors, status: :unprocessable_entity }
      end
    end      
  end
  

  # DELETE /security_groups/1
  # DELETE /security_groups/1.json
  def destroy
    @security_group = RdsSecurityGroup.find(params[:id])

    respond_to do |format|
      begin
        @security_group.destroy
        format.html { redirect_to admin_rds_security_groups_url }
        format.json { head :ok }
      rescue => e
        format.html { redirect_to [:admin, @security_group], alert: pretty_error(e.message) }
        format.json { render json: @security_group.errors, status: :unprocessable_entity }
      end
        
    end
  end
  

end
