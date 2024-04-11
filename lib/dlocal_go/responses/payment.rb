# frozen_string_literal: true

module DlocalGo
  module Responses
    # Class that represents Dlocal Go payment schema
    class Payment
      RESPONSE_ATTRIBUTES = %i[id amount currency country order_id description notification_url success_url back_url redirect_url
                               payment_method_type created_date approved_date status merchant_checkout_token direct].freeze


      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response)
        RESPONSE_ATTRIBUTES.each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute) || response.send(attribute.to_s.camelize(:lower)))
        end
      end
    end
  end
end
