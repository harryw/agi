class Stack::DeploymentsController < ApplicationController

  def new
    load_deployment_data
    @stack_deployment = StackDeployment.new
  end
  
  def create
  end


  private
  
    def load_deployment_data
      @chef_account = ChefAccount.find(params[:stack_id])
      @deployment_data = Dependency.generate_deployment_data(@chef_account)
    end
end