# frozen_string_literal: true

require_relative "base"

require_relative "subscription_plan"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription schema
    class Subscription < DlocalGo::Responses::Base
      has_attributes %i[
        id
        country
        subscription_token
        status
        language
        scheduled_date
        active
        client_id
        client_first_name
        client_last_name
        client_document_type
        client_document
        client_email
        card_token
        created_at
        updated_at
      ]

      has_association :plan, DlocalGo::Responses::SubscriptionPlan
    end
  end
end
