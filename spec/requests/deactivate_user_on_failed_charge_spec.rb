require 'spec_helper'

describe 'De-activate the user on a failed charge' do
  let!(:user) { Fabricate(:user, customer_token: 'cus_8nBIV6oBYGIS0w')}
  let(:event_data) do
    {
      "id" => "evt_18WJo6JLgmzjspxRrawRplVH",
      "object" => "event",
      "api_version" => "2016-06-15",
      "created" => 1468302706,
      "data" => {
        "object" => {
          "id" => "ch_18WJo6JLgmzjspxR7NQscx7M",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1468302706,
          "currency" => "usd",
          "customer" => "cus_8nBIV6oBYGIS0w",
          "description" => "failed charge",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_18WJo6JLgmzjspxR7NQscx7M/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_18WJaFJLgmzjspxRq8HaxYwf",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_8nBIV6oBYGIS0w",
            "cvc_check" => nil,
            "dynamic_last4" => nil,
            "exp_month" => 7,
            "exp_year" => 2022,
            "fingerprint" => "WHE2pEGP3JYbS4sK",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8nvfDZyyrnG74O",
      "type" => "charge.failed"
    }
  end
  it 'De-activate a user with web hook data from stripe for charge failed', :vcr do
    post '/stripe_events', event_data
    expect(user.reload).not_to be_active
  end
end
