class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_sign_in
    access_denied unless logged_in?
  end

  def require_admin
    unless current_user.admin?
      flash[:error] = 'You do no have admin access'
      redirect_to home_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def access_denied
    flash[:error] = "You are not allowed to do that"
    redirect_to sign_in_path
  end

  helper_method :logged_in?, :current_user

end
