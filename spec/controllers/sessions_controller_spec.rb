require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the new tempalte for unauthenticated user" do
      get :new
      expect(response).to render_template :new
    end
    it 'redirects to home path for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid input" do
      let(:alice) { Fabricate(:user) }
      before do
        post :create, email: alice.email, password: alice.password
      end
      it 'puts the signed in user id into settion' do
        expect(session[:user_id]).to eq(alice.id)
      end
      it 'sets notice' do
        expect(flash[:notice]).not_to be_blank
      end
      it 'redirect to home path' do
        expect(response).to redirect_to home_path
      end
    end
    context "with invalid input" do
      let(:alice) { Fabricate(:user) }
      before do
        post :create, email: alice.email, password: alice.password + 'wrong'
      end
      it 'does not populate session with user id' do
        expect(session[:user_id]).to be_nil
      end
      it 'redirect to the sign in path' do
        expect(response).to redirect_to sign_in_path
      end
      it 'sets the error message in flash' do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it 'clears the session for the user' do
      expect(session[:user_id]).to be_nil
    end
    it 'sets notice' do
      expect(flash[:notice]).not_to be_blank
    end
    it 'redirect to root path' do
      expect(response).to redirect_to root_path
    end
  end
end
