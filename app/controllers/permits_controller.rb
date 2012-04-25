class PermitsController < ApplicationController





  # POST /permits
  # POST /permits.json
  def create
    @dependency = Dependency.find(params[:stack_id])
    @permit = @dependency.permits.new(params[:permit])

    respond_to do |format|
      if @permit.save
        format.html { redirect_to stack_path(@dependency.chef_account), notice: 'permit was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end


  def destroy
    @dependency = Dependency.find(params[:stack_id])
    @permit = Permit.find(params[:id])
    @permit.destroy

    respond_to do |format|
      format.html { redirect_to stack_path(@dependency.chef_account) }
    end
  end
end