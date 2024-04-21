require_relative "base"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go recurring payment schema
    class RecurringPayment < DlocalGo::Responses::Base
      has_attributes %i[
        currency
        amount
        recurring_link_token
        enabled
      ]
    end
  end
end
