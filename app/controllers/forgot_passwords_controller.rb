class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by email: params[:email]
    if user
      user.generate_token
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = 'something is wrong with that email'
      redirect_to forgot_password_path
    end
  end

  def confirm; end
end
