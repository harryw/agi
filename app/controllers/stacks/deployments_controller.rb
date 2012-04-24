class Stacks::DeploymentsController < ApplicationController

  def new
    @stack_deployment = StacksDeployment.new
  end
  
  def create
  end

end