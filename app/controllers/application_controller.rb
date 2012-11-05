class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate 
    unless session[:user_id].present?
      session[:redirect_to] = request.url
      redirect_to :login 
    end
  end

end
