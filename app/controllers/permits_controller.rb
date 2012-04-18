class PermitsController < ApplicationController





  # POST /permits
  # POST /permits.json
  def create
    @dependency = Dependency.find(params[:stack_id])
    @permit = @dependency.permits.new(params[:permit])

    respond_to do |format|
      if @permit.save
        format.html { redirect_to stacks_path, notice: 'permit was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end


  def destroy
    @permit = Permit.find(params[:id])
    @permit.destroy

    respond_to do |format|
      format.html { redirect_to stacks_path }
    end
  end
end