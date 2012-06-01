class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter CASClient::Frameworks::Rails::Filter  # require login
  before_filter :ensure_cas_user_exists
  
  # Checks the email of the CAS user against the Users in the database.
  # Redirects to the Projects list page with a flash error if not.
  def ensure_cas_user_exists
    unless (User.all.map {|u| u.username}).include? session[:cas_user]
      flash[:error] = "You must be a registered user of Agi"
      redirect_to projects_path
    end
  end

  protected
  
  def load_app
      @app = App.find(params[:app_id])
  end
  
  def pretty_error(message)
    "Error. HTTP Code: " + parse_response_code(message) + ' Message: ' + parse_json_body_errors(message)
  end
  
  def parse_response_code(message)
    message.scan(/Response code = (\d+)/).join
  end
    
  
  def parse_json_body_errors(message)
    # it returns an array of an array because grouping () is used, join flats it and turns it into a string
    body = message.scan(/Response body = (.*)\./).join
    decoded = ActiveSupport::JSON.decode(body) || {} rescue {}
    error = decoded['errors'] || []
    error.join
  end
end
