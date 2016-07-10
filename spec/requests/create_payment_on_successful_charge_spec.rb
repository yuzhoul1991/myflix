require 'spec_helper'

describe 'Create payment on successful charge' do
  let!(:user) { Fabricate(:user, customer_token: 'cus_8moATYMWcTjbXK')}
  let (:event_data) {
    {
      "id" => "evt_18VEY6JLgmzjspxR05eCUggm",
      "object" => "event",
      "api_version" => "2016-06-15",
      "created" => 1468044166,
      "data" => {
        "object" => {
          "id" => "ch_18VEY6JLgmzjspxRzAIK3JNR",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => "txn_18VEY6JLgmzjspxRuPLI9xUF",
          "captured" => true,
          "created" => 1468044166,
          "currency" => "usd",
          "customer" => "cus_8moATYMWcTjbXK",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_18VEY6JLgmzjspxRLlxXp6ej",
          "livemode" => false,
          "metadata" => {
          },
          "order" => nil,
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [

            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_18VEY6JLgmzjspxRzAIK3JNR/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_18VEY6JLgmzjspxRKYxNHGkq",
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
            "customer" => "cus_8moATYMWcTjbXK",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 7,
            "exp_year" => 2018,
            "fingerprint" => "9FEo4dI0jvLgWi8a",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "succeeded"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_8moAkQBd7VIHSG",
      "type" => "charge.succeeded"
    }
  }
  before do
    post '/stripe_events', event_data
  end
  it 'creates a payment with the webhook from stripe for charge succeeded event', :vcr do
    expect(Payment.count).to eq(1)
  end
  it 'creates the payment associated witht the user', :vcr do
    expect(Payment.first.user).to eq(user)
  end
  it 'creates the payment with the amount', :vcr do
    expect(Payment.first.amount).to eq(999)
  end
  it 'creates the payment with reference id', :vcr do
    expect(Payment.first.reference_id).to eq('ch_18VEY6JLgmzjspxRzAIK3JNR')
  end
end
