class AddonsController < ApplicationController
  # GET /addons
  # GET /addons.json
  def index
    @addons = Addon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @addons }
    end
  end

  # GET /addons/1
  # GET /addons/1.json
  def show
    @addon = Addon.find(params[:id])
    @customizations = @addon.customizations
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @addon }
    end
  end

  # GET /addons/new
  # GET /addons/new.json
  def new
    @addon = Addon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @addon }
    end
  end

  # GET /addons/1/edit
  def edit
    @addon = Addon.find(params[:id])
  end

  # POST /addons
  # POST /addons.json
  def create
    @addon = Addon.new(params[:addon])

    respond_to do |format|
      if @addon.save
        format.html { redirect_to @addon, notice: 'Addon was successfully created.' }
        format.json { render json: @addon, status: :created, location: @addon }
      else
        format.html { render action: "new" }
        format.json { render json: @addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /addons/1
  # PUT /addons/1.json
  def update
    @addon = Addon.find(params[:id])

    respond_to do |format|
      if @addon.update_attributes(params[:addon])
        format.html { redirect_to @addon, notice: 'Addon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @addon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addons/1
  # DELETE /addons/1.json
  def destroy
    @addon = Addon.find(params[:id])
    @addon.destroy

    respond_to do |format|
      format.html { redirect_to addons_url }
      format.json { head :no_content }
    end
  end
end
