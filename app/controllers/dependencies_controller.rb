class DependenciesController < ApplicationController
  # GET /stacks
  # GET /stacks.json
  def index
    @frontends = Dependency.all.map {|d| d.app if d.backend }.compact
    
    @permit = Permit.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /stacks/1
  # GET /stacks/1.json
  def show
    @stacks = Dependency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stack }
    end
  end

  # GET /stacks/new
  # GET /stacks/new.json
  def new
    @stack = Dependency.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stack }
    end
  end

  # GET /stacks/1/edit
  def edit
    @stack = stack.find(params[:id])
  end

  # POST /stacks
  # POST /stacks.json
  def create
    @stack = Dependency.new(params[:dependency])

    respond_to do |format|
      if @stack.save
        format.html { redirect_to stacks_path, notice: 'stack was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /stacks/1
  # PUT /stacks/1.json
  def update
    @stack = stack.find(params[:id])


    respond_to do |format|
      if @stack.update_attributes(params[:stack])
        format.html { redirect_to @stack, notice: 'stack was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stacks/1
  # DELETE /stacks/1.json
  def destroy
    @stack = stack.find(params[:id])
    @stack.destroy

    respond_to do |format|
      format.html { redirect_to stacks_url }
      format.json { head :ok }
    end
  end
end