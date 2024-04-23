# frozen_string_literal: true

require_relative "base"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription plan schema
    class SubscriptionPlan < DlocalGo::Responses::Base
      has_attributes %i[
        id
        merchant_id
        name
        description
        country
        currency
        amount
        frequency_type
        frequency_value
        active
        free_trial_days
        plan_token
        back_url
        notification_url
        success_url
        error_url
        created_at
        updated_at
      ]
    end
  end
end
