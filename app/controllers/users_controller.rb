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

    if @user.save
      handle_invitation
      charge_status = charge_credit_card(params)
      flash[:notice] = "You have successfully registered"
      AppMailer.delay.send_welcome_email(@user)
      if charge_status
        redirect_to sign_in_path
      else
        render :new
      end
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def charge_credit_card(params)
    token = params[:stripeToken]
    begin
      StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
      )
      flash[:notice] = "Your card has been charged $9.99, Thank you"
    rescue Stripe::CardError => e
      flash[:error] = "There was something wrong with processing your credit card"
      return false
    end
    true
  end

  def user_params
    params.require(:user).permit(:email, :fullname, :password)
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_attribute(:token, nil)
    end
  end
end
