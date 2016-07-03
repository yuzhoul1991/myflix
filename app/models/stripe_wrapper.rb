module StripeWrapper
  class Charge
    def self.create(options={})
      binding.pry
      StripeWrapper.set_api_key
      Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        source: options[:token],
        description: options[:description]
      )
    end
  end

  def self.set_api_key
    Stripe.api_key = "#{ENV['STRIPE_SECRET_KEY']}"
  end
end
