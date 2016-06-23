class InvitationsController < ApplicationController
  before_filter :require_sign_in

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter_id = current_user.id
    if @invitation.save
      @invitation.generate_token
      AppMailer.send_invitation(@invitation).deliver
      flash[:notice] = "You have sent your invitation"
      redirect_to new_invitation_path
    else
      flash[:error] = "Something went wrong"
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:recipient_email, :recipient_name, :message)
  end
end
