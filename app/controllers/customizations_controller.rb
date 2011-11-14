class CustomizationsController < ApplicationController
  # GET /customizations
  # GET /customizations.json
  def index
    @customizable = find_customizable
    @customizations = @customizable.customizations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customizations }
    end
  end

  # GET /customizations/1
  # GET /customizations/1.json
  def show
    @customizable = find_customizable
    
    @customization = Customization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customization }
    end
  end

  # GET /customizations/new
  # GET /customizations/new.json
  def new
    @customizable = find_customizable
    
    @customization = Customization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customization }
    end
  end

  # GET /customizations/1/edit
  def edit
    @customizable = find_customizable
    @customization = Customization.find(params[:id])
  end

  # POST /customizations
  # POST /customizations.json
  def create
    @customizable = find_customizable
    @customization = @customizable.customizations.build(params[:customization])

    respond_to do |format|
      if @customization.save
        format.html { redirect_to [@customizable, Customization], notice: 'Customization was successfully created.' }
        format.json { render json: @customization, status: :created, location: @customization }
      else
        format.html { render action: "new" }
        format.json { render json: @customization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customizations/1
  # PUT /customizations/1.json
  def update
    @customizable = find_customizable
    @customization = Customization.find(params[:id])

    respond_to do |format|
      if @customization.update_attributes(params[:customization])
        format.html { redirect_to [@customizable, Customization], notice: 'Customization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @customization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customizations/1
  # DELETE /customizations/1.json
  def destroy
    @customizable = find_customizable
    @customization = Customization.find(params[:id])
    @customization.destroy

    respond_to do |format|
      format.html { redirect_to [@customizable, Customization] }
      format.json { head :ok }
    end
  end
  
  private
  
  def find_customizable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
