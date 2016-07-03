require 'spec_helper'

describe UsersController do
  describe  "GET new" do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end
    context 'with authenticated user' do
      let(:user) { Fabricate(:user) }
      before do
        set_current_user
        get :show, id: user.id
      end
      it 'sets the variable @user' do
        expect(assigns(:user)).to eq(user)
      end
    end
  end

  describe "POST create" do
    before do
      StripeWrapper::Charge.stub(:create)
    end
    context "with valid input" do
      let(:inviter) { Fabricate(:user) }
      let(:invitation) { Fabricate(:invitation, inviter: inviter) }
      before do
        invitation.generate_token
        post :create, user: Fabricate.attributes_for(:user, email: 'recipient@email.com'), invitation_token: invitation.token
      end
      after do
        ActionMailer::Base.deliveries.clear
      end
      it "creates the user" do
        expect(User.count).to eq(2)
      end
      it 'redirect to sign in path' do
        expect(response).to redirect_to sign_in_path
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
    end
    context "with invalid input" do
      before do
        post :create, user: { password: 'password', fullname: Faker::Name.name }
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it 'render the :new template' do
        expect(response).to render_template :new
      end
      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    context 'sending emails' do
      let(:user) { Fabricate.attributes_for(:user) }
      after do
        ActionMailer::Base.deliveries.clear
      end
      it 'sends out email to user with valid inputs' do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.to).to eq([user[:email]])
      end
      it 'sends out email with the user fullname' do
        post :create, user: user
        expect(ActionMailer::Base.deliveries.last.body).to include(user[:fullname])
      end
      it 'does not send email with invalid inputs' do
        post :create, user: user.merge!(fullname: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe 'GET new_with_invitation' do
    let(:invitation) { Fabricate(:invitation) }
    before do
      invitation.generate_token
    end
    it "prefill the @user.email field" do
      get :new_with_invitation, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    it "sets the @invitation_token variable" do
      get :new_with_invitation, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    it "should render the new template" do
      get :new_with_invitation, token: invitation.token
      expect(response).to render_template :new
    end
    it "redirects to expired token path if the token is expeired" do
      get :new_with_invitation, token: 'expired_token'
      expect(response).to redirect_to expired_token_path
    end
  end
end
