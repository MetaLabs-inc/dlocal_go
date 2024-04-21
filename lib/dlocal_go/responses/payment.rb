require_relative "base"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go payment schema
    class Payment < DlocalGo::Responses::Base
      has_attributes %i[
        id
        amount
        currency
        country
        created_date
        status
        order_id
        success_url
        back_url
        redirect_url
        notification_url
        merchant_checkout_token
        approved_date
        description
        direct
      ]
    end
  end
end
