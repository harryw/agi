class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!, :except => [:app_status]
  
  def app_status
    render(:json => "OK", :status => 200)
  end
  
  
  protected
  
  def load_app
      @app = App.find(params[:app_id])
  end
end
