module Tokenable
  extend ActiveSupport::Concern

  included do
    def generate_token
        self.update_attribute :token, SecureRandom.urlsafe_base64
    end
  end
end
