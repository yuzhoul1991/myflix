require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create' do
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
      it 'can make a successful charge', :vcr do
        charge = StripeWrapper::Charge.create(
          amount: 999,
          token: success_token,
          description: 'a valid charge'
        )
        expect(charge).to be_successful
      end
      it 'make an invalid charge', :vcr do
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
end
