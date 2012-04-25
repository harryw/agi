class DependenciesController < ApplicationController
  # GET /stacks
  # GET /stacks.json
  def index

  end

  # GET /stacks/1
  # GET /stacks/1.json
  def show
    @chef_account = ChefAccount.find(params[:id])
    
    @frontends = @chef_account.dependencies.get_all_frontends
    @permit = Permit.new
    
    @stack = Dependency.new

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
        format.html { redirect_to stack_path(@stack.chef_account), notice: 'stack was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end



  # DELETE /stacks/1
  # DELETE /stacks/1.json
  def destroy
    @stack = Dependency.find(params[:id])
    @chef_account = @stack.chef_account
    @stack.destroy

    respond_to do |format|
      format.html { redirect_to stack_url(@chef_account) }
      format.json { head :ok }
    end
  end
end