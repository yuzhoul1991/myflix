module StripeWrapper
  class Charge
    attr_reader :error_message

    def initialize(args={})
      @response = args.fetch(:response, nil)
      @error_message = args.fetch(:error_message, nil)
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          source: options[:token],
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      @response.present?
    end
  end
end
