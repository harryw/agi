class Admin::Rds::ServersController < ApplicationController
    # GET /databases
    # GET /databases.json
    def index
      @servers = RdsServer.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @servers }
      end
    end

    # GET /databases/1
    # GET /databases/1.json
    def show
      @server = RdsServer.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @server }
      end
    end

    # GET /databases/new
    # GET /databases/new.json
    def new
      @server = RdsServer.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @server }
      end
    end

    # GET /databases/1/edit
    def edit
      @server = RdsServer.find(params[:id])
    end

    # POST /databases
    # POST /databases.json
    def create
      @server = RdsServer.new(params[:rds_server])

      respond_to do |format|
        if @server.save
          format.html { redirect_to [:admin, @server], notice: 'RdsServer was successfully created.' }
          format.json { render json: [:admin, @server], status: :created, location: [:admin, @server] }
        else
          format.html { render action: "new" }
          format.json { render json: @server.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /databases/1
    # PUT /databases/1.json
    def update
      @server = RdsServer.find(params[:id])

      respond_to do |format|
        if @server.update_attributes(params[:rds_server])
          format.html { redirect_to [:admin, @server], notice: 'RdsServer was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @server.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /databases/1
    # DELETE /databases/1.json
    def destroy
      @server = RdsServer.find(params[:id])
      @server.destroy

      respond_to do |format|
        format.html { redirect_to admin_rds_servers_url }
        format.json { head :ok }
      end
    end


end
  