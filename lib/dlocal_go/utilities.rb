require_relative "constants"

module DlocalGo
  # Utilities for using the Dlocal Go API
  class Utilities
    include Constants

    class << self
      def subscription_url(token:, email: nil)
        new.subscription_url(token: token, email: email)
      end
    end

    def subscription_url(token:, email: nil)
      email.present? ? "#{subscription_base_url}/#{token}?email=#{email}" : "#{base_url}#{token}"
    end
  end
end
