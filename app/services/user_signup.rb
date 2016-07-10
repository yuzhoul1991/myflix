class UserSignup
  attr_reader :user, :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      response = StripeWrapper::Customer.create(
        :user => @user,
        :amount => 999,
        :token => stripe_token,
      )
      if response.successful?
        @user.customer_token = response.customer_token
        @user.save
        handle_invitation(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = response.error_message
        self
      end
    else
      @status = :failed
      @error_message = 'Invalid user information, please correct and try again.'
      self
    end
  end

  def successful?
    @status == :success
  end

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_attribute(:token, nil)
    end
  end
end
