# frozen_string_literal: true

require_relative "base"
require_relative "subscription"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription plan execution schema
    class SubscriptionExecution < DlocalGo::Responses::Base
      has_attributes %i[
        id
        status
        order_id
        merchant_checkout_id
        currency
        amount_paid
        amount_received
        checkout_currency
        balance_currency
        created_at
        updated_at
      ]

      has_association :subscription, DlocalGo::Responses::Subscription
    end
  end
end
