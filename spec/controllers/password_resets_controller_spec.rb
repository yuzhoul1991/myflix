require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    let(:user) { Fabricate(:user) }
    it 'renders show template if the token is valid' do
      user.generate_token
      get :show, id: user.token
      expect(response).to render_template :show
    end
    it 'redirects to the expired token page if the token is not valid' do
      get :show, id: '11111'
      expect(response).to redirect_to expired_token_path
    end
    it 'sets variable @token' do
      user.generate_token
      get :show, id: user.token
      expect(assigns(:token)).to be(user.token)
    end
  end

  describe 'POST create' do
    context 'with valid inputs' do
      let(:user) { Fabricate(:user, password: 'old password') }
      before do
        user.generate_token
        post :create, token: user.token, password: 'new password'
      end
      it 'should update the users password' do
        expect(User.first.authenticate('new password')).to be_truthy
      end
      it 'should redirect to the sign in page' do
        expect(response).to redirect_to sign_in_path
      end
      it 'sets a flash success message' do
        expect(flash[:success]).not_to be_nil
      end
      it 'should remove the users token from database' do
        expect(User.first.token).to be_nil
      end
    end
    context 'with invalid inputs' do
      let(:user) { Fabricate(:user, password: 'old password') }
      before do
        user.generate_token
        post :create, token: 'wrong token', password: 'new password'
      end
      it 'redirect to the expired token page' do
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
