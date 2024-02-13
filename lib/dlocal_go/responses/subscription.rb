# frozen_string_literal: true

require_relative "subscription_plan"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription schema
    class Subscription
      RESPONSE_ATTRIBUTES = %i[
        id country subscription_token status language scheduled_date active client_id client_first_name client_last_name
        client_document_type client_document client_email card_token plan created_at updated_at
      ].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        (RESPONSE_ATTRIBUTES - %i[plan]).each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute))
        end

        @plan = SubscriptionPlan.new(OpenStruct.new(response["plan"]))
      end
    end
  end
end
