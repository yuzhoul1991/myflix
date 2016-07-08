require 'spec_helper'

describe UserSignup do
  describe '#sign_up' do
    context "with valid personal info and valid credit card info" do
      let(:charge) { double(:charge, successful?: true) }
      let(:inviter) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: inviter, recipient_email: 'recipient@example.com') }
      before do
        StripeWrapper::Charge.stub(:create).and_return(charge)
        invitation.generate_token
        UserSignup.new(Fabricate.build(:user, email: 'recipient@email.com')).sign_up('stripe token', invitation.token)
      end
      after do
        ActionMailer::Base.deliveries.clear
      end
      it "creates the user" do
        expect(User.count).to eq(2)
      end
      it "makes the user follow the inviter" do
        invitee = User.where(email: 'recipient@email.com').first
        expect(invitee.following?(inviter)).to be_truthy
      end
      it "makes the inviter follow the user" do
        invitee = User.where(email: 'recipient@email.com').first
        expect(inviter.following?(invitee)).to be_truthy
      end
      it "expires the invitation token" do
        expect(invitation.reload.token).to be_nil
      end
      it 'sends out email to user with valid inputs' do
        invitee = User.where(email: 'recipient@email.com').first
        expect(ActionMailer::Base.deliveries.last.to).to eq([invitee.email])
      end
      it 'sends out email with the user fullname' do
        invitee = User.where(email: 'recipient@email.com').first
        expect(ActionMailer::Base.deliveries.last.body).to include(invitee.fullname)
      end
    end

    context 'with valid personal info and declined credit card' do
      before do
        charge = double(:charge, successful?: false, error_message: 'card declined')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        UserSignup.new(Fabricate.build(:user)).sign_up('stripe token', nil)
      end
      it 'does not create user record' do
        expect(User.count).to eq(0)
      end
      it 'does not send email with invalid inputs' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid personal info" do
      before do
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up('stripe token', nil)
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it 'does not charge the credit card' do
        StripeWrapper::Charge.should_not_receive(:create)
        UserSignup.new(Fabricate.build(:user, email: nil)).sign_up('stripe token', nil)
      end
      it 'does not send email with invalid inputs' do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
