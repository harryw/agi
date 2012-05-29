class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter CASClient::Frameworks::Rails::Filter  # require login
  
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
