class UsersController < ApplicationController
  before_filter :require_sign_in, only: [:show]
  def new
    @user = User.new
  end

  def new_with_invitation
    invitation = Invitation.find_by token: params[:token]
    if invitation
      @user = User.new email: invitation.recipient_email
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    status = UserSignup.new(@user).sign_up params[:stripeToken], params[:invitation_token]
    if status.successful?
      flash[:notice] = "You have successfully registered"
      redirect_to sign_in_path
    else
      flash[:error] = status.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email, :fullname, :password)
  end

end
