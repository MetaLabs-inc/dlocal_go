require "http"

module DlocalGo
  module Generators
    module Constants
      SANDBOX_URL = "https://api-sbx.dlocalgo.com"
      PRODUCTION_URL = "https://api.dlocalgo.com"

      SUBSCRIPTION_BASE_SANDBOX_URL = "https://checkout-sbx.dlocalgo.com/validate/subscription/"
      SUBSCRIPTION_BASE_PRODUCTION_URL = "https://checkout.dlocalgo.com/validate/subscription/"

      DEFAULT_SUPPORTED_COUNTRIES = %w[UY AR CL BO BR CO CR EC GT ID MX MY PE PY].freeze
      CURRENCY_FOR_COUNTRY = { UY: "UYU", AR: "ARS", CL: "CLP", BO: "BOB", BR: "BRL",
                               CO: "COP", CR: "CRC", EC: "USD", GT: "GTQ", ID: "IDR", MX: "MXN",
                               MY: "MYR", PE: "PEN", PY: "PYG" }.freeze

      def currency_for_country(country)
        CURRENCY_FOR_COUNTRY[country.to_sym]
      end
    end
  end
end