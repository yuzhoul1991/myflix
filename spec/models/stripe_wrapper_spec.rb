require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
      let(:token) {
        Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 6,
            :exp_year => 2017,
            :cvc => "314"
          },
        ).id
      }
      it 'can make a successful charge', :vcr do
        Stripe.api_key = "#{ENV['STRIPE_SECRET_KEY']}"
        response = StripeWrapper::Charge.create(
          amount: 999,
          token: token,
          description: 'a valid charge'
        )
        expect(response.amount).to eq(999)
        expect(response.currency).to eq('usd')
      end
    end
  end
end
