# frozen_string_literal: true

module DlocalGo
  module Responses
    class Refund
      RESPONSE_ATTRIBUTES = %i[id amount status].freeze

      attr_reader *RESPONSE_ATTRIBUTES

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute))
        end
      end
    end
  end
end
