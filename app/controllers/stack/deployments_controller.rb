class Stack::DeploymentsController < ApplicationController

  def new
    @chef_account = ChefAccount.find(params[:stack_id])
    load_deployment_data
    @stack_deployment = @chef_account.stack_deployments.new
  end
  
  def create
    @chef_account = ChefAccount.find(params[:stack_id])
    @deployment = @chef_account.stack_deployments.build(params[:stack_deployment])
    
    
    respond_to do |format|
      if @deployment.save
        format.html { redirect_to stack_deployment_path(@deployment.chef_account,@deployment), notice: 'stack was successfully deployed.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def show
    @deployment = StackDeployment.find(params[:id])
  end


  private
  
    def load_deployment_data
      
      @deployment_data = Dependency.generate_deployment_data(@chef_account)
    end
end