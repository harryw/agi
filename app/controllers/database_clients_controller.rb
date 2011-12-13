class DatabaseClientsController < ApplicationController
  # GET /databases
  # GET /databases.json
  def index
    @databases = DatabaseClient.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @databases }
    end
  end

  # GET /databases/1
  # GET /databases/1.json
  def show
    @database = DatabaseClient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @database }
    end
  end

  # GET /databases/new
  # GET /databases/new.json
  def new
    @database = DatabaseClient.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @database }
    end
  end

  # GET /databases/1/edit
  def edit
    @database = DatabaseClient.find(params[:id])
  end

  # POST /databases
  # POST /databases.json
  def create
    @database = DatabaseClient.new(params[:database_client])

    respond_to do |format|
      if @database.save
        format.html { redirect_to @database, notice: 'DatabaseClient was successfully created.' }
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
    @database = DatabaseClient.find(params[:id])

    respond_to do |format|
      if @database.update_attributes(params[:database_client])
        format.html { redirect_to @database, notice: 'DatabaseClient was successfully updated.' }
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
    @database = DatabaseClient.find(params[:id])
    @database.destroy

    respond_to do |format|
      format.html { redirect_to database_clients_url }
      format.json { head :ok }
    end
  end
  

end
