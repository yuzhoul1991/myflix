class PasswordResetsController < ApplicationController
  def show
    user = User.find_by token: params[:id]
    if user
      @token = params[:id]
    else
      redirect_to expired_token_path unless user
    end
  end

  def create
    user = User.find_by token: params[:token]
    if user
      user.password = params[:password]
      user.token = nil
      if user.save
        flash[:success] = 'You password has been changed'
        redirect_to sign_in_path
      else
        flash[:error] = 'Something is wrong with the new password'
        render :show
      end
    else
      redirect_to expired_token_path
    end
  end

  def expired_token; end
end
