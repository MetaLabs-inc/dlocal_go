# frozen_string_literal: true

module DlocalGo
  module Responses
    # Class that represents Dlocal Go refund schema
    class Refund
      RESPONSE_ATTRIBUTES = %i[id amount status].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute) || response.send(attribute.to_s.camelize(:lower)))
        end
      end
    end
  end
end
