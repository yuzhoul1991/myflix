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
    context "successful user sign up" do
      it 'redirect to sign in path' do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'failed user sign up' do
      before do
        result = double(:sign_up_result, successful?: false, error_message: 'error message')
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end
      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it 'renders the new template' do
        expect(response).to render_template :new
      end
      it 'set the flash error message' do
        expect(flash[:error]).to be_present
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
