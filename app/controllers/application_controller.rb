class ApplicationController < ActionController::Base
  protect_from_forgery

  def authenticate
  	authenticate_or_request_with_http_basic do |user, password|
    	user == "yalecasa" && password == "casarocks"
	end
  end

end
