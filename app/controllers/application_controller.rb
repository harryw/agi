class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
  protected
  
  def load_app
      @app = App.find(params[:app_id])
  end
end
