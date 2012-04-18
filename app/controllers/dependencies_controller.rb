class DependenciesController < ApplicationController
  # GET /stacks
  # GET /stacks.json
  def index
    @frontends = Dependency.all.map {|d| d.app if d.backend }.compact
    
    @permit = Permit.new
    
    @stack = Dependency.new
    

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



  # DELETE /stacks/1
  # DELETE /stacks/1.json
  def destroy
    @stack = Dependency.find(params[:id])
    @stack.destroy

    respond_to do |format|
      format.html { redirect_to stacks_url }
      format.json { head :ok }
    end
  end
end