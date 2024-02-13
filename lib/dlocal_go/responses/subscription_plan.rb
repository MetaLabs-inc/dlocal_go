# frozen_string_literal: true

module DlocalGo
  module Responses
    # Class that represents Dlocal Go subscription plan schema
    class SubscriptionPlan
      RESPONSE_ATTRIBUTES = %i[
        id merchand_id name description country currency amount frequency_type frequency_value active free_trial_days
        plan_token back_url notification_url success_url error_url created_at updated_at
      ].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute))
        end
      end
    end
  end
end
