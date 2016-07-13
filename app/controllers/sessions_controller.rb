class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    if user and user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:notice] = "You have logged in"
        redirect_to home_path
      else
        flash[:error] = "Your account has been suspended, please contact customer service."
        redirect_to sign_in_path
      end
    else
      flash[:error] = "Invalid email or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have signed out"
    redirect_to root_path
  end
end
