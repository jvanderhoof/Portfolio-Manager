class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    if session[:redirect_to].present?
      redirect_to session.delete(:redirect_to), :notice => "Signed in!"
    else
      redirect_to accounts_path, :notice => "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Signed out!"
  end

  def failure
    redirect_to login_path, :alert => "Authentication failed, please try again."
  end
end
