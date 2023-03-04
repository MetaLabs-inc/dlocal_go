# frozen_string_literal: true

module DlocalGo
  module Responses
    class Payment
      RESPONSE_ATTRIBUTES = %i[id amount currency country created_date status order_id success_url back_url
                               redirect_url merchant_checkout_token direct].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute))
        end
      end
    end
  end
end
