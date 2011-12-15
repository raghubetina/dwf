require 'open-uri'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user, :logged_in?
  
  def logged_in?
    session[:user_id]
  end
  
  def current_user
    if session[:user_id]
      return User.find(session[:user_id])
    end
  end
  
end
