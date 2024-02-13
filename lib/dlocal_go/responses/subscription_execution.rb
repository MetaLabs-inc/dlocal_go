# frozen_string_literal: true

require_relative "subscription"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription plan execution schema
    class SubscriptionExecution
      RESPONSE_ATTRIBUTES = %i[
        id subscription status order_id merchant_checkout_id currency amount_paid amount_received checkout_currency
        balance_currency created_at updated_at
      ].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        (RESPONSE_ATTRIBUTES - %i[subscription]).each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute))
        end

        @subscription = Subscription.new(OpenStruct.new(response["subscription"]))
      end
    end
  end
end
