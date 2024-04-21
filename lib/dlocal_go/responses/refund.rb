require_relative "base"

module DlocalGo
  module Responses
    # Class that represents Dlocal Go refund schema
    class Refund < DlocalGo::Responses::Base
      has_attributes %i[
        id
        amount
        status
      ]
    end
  end
end
