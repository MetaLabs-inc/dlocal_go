# frozen_string_literal: true

module DlocalGo
  module Responses
    # Class that represents Dlocal Go recurring payment schema
    class RecurringPayment
      RESPONSE_ATTRIBUTES = %i[currency amount recurring_link_token enabled].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute) || response.send(attribute.to_s.camelize(:lower)))
        end
      end
    end
  end
end
