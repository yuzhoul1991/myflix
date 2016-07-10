require 'spec_helper'

describe StripeWrapper, :vcr do
  let(:success_token) {
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 6,
        :exp_year => 2017,
        :cvc => "314"
      },
    ).id
  }
  let(:declined_token) {
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 6,
        :exp_year => 2017,
        :cvc => "314"
      },
    ).id
  }
  describe StripeWrapper::Charge do
    describe '.create' do
      it 'can make a successful charge' do
        charge = StripeWrapper::Charge.create(
          amount: 999,
          token: success_token,
          description: 'a valid charge'
        )
        expect(charge).to be_successful
      end
      it 'make an invalid charge' do
        charge = StripeWrapper::Charge.create(
          amount: 900,
          token: declined_token,
          description: 'a declined charge'
        )
        expect(charge).not_to be_successful
        expect(charge.error_message).to eq('Your card was declined.')
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      let(:user) { Fabricate(:user) }
      it 'creates a customer with a valid card' do
        response = StripeWrapper::Customer.create(
          user: user,
          token: success_token,
          description: 'a valid charge'
        )
        expect(response).to be_successful
      end
      it 'does not create a customer with declined card' do
        response = StripeWrapper::Customer.create(
          user: user,
          token: declined_token,
          description: 'a valid charge'
        )
        expect(response).not_to be_successful
        expect(response.error_message).to eq('Your card was declined.')
      end
      it 'returns the customer token for a valid card' do
        response = StripeWrapper::Customer.create(
          user: user,
          token: success_token,
          description: 'a valid charge'
        )
        expect(response.customer_token).to be_present
      end
    end
  end
end
