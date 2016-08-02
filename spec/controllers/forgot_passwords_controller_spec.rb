require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank email input' do
      before do
        post :create, email: ""
      end
      it 'redirect to forgot password page' do
        expect(response).to redirect_to forgot_password_path
      end
      it 'sets error message' do
        expect(flash[:error]).not_to be_empty
      end
    end
    context 'with existing email' do
      let(:user) { Fabricate(:user) }
      before do
        post :create, email: user.email
      end
      after do
        ActionMailer::Base.deliveries.clear
      end
      it 'redirect to forgot password confirmation page' do
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      it 'sends out an email to the email address provided' do
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end
      it 'generates a token and save to database for the user' do
        expect(User.first.token).not_to be_nil
      end
    end
    context 'with non-existing email' do
      before do
        post :create, email: 'non-existing@email.com'
      end
      it 'redirect to the forgot password page' do
        expect(response).to redirect_to forgot_password_path
      end
      it 'sets error message' do
        expect(flash[:error]).not_to be_empty
      end
    end
  end
end
