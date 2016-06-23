require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    let(:user) { Fabricate(:user) }
    before do
      session[:user_id] = user.id
      get :new
    end
    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end
    it 'sets @invitation variable' do
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe 'POST :create' do
    it_behaves_like "requires sign in" do
      let(:action) {post :create, invitation: Fabricate.attributes_for(:invitation)}
    end
    context 'with valid inputs' do
      let(:inviter) { Fabricate(:user) }
      after do
        ActionMailer::Base.deliveries.clear
      end
      before do
        session[:user_id] = inviter.id
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: 'recipient@email.com')
      end
      it 'creates an invitation' do
        expect(Invitation.all.count).to be(1)
      end
      it 'redirects to the new invitation path' do
        expect(response).to redirect_to new_invitation_path
      end
      it 'sets the flash notice message' do
        expect(flash[:notice]).not_to be_nil
      end
      it 'sends an email to the recipient' do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['recipient@email.com'])
      end
    end
    context 'with invalid inputs' do
      let(:inviter) { Fabricate(:user) }
      before do
        session[:user_id] = inviter.id
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
      end
      after do
        ActionMailer::Base.deliveries.clear
      end
      it "should render the new template" do
        expect(response).to render_template :new
      end
      it "sets an error flash message" do
        expect(flash[:error]).not_to be_nil
      end
      it "does not send an invitation email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "sets @invitation variable" do
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
