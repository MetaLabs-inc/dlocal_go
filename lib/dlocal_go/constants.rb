# frozen_string_literal: true

module DlocalGo
  # Constants we'll use throughout the gem
  module Constants
    SANDBOX_URL = "https://api-sbx.dlocalgo.com"
    PRODUCTION_URL = "https://api.dlocalgo.com"

    SUBSCRIPTION_BASE_SANDBOX_URL = "https://checkout-sbx.dlocalgo.com/validate/subscription"
    SUBSCRIPTION_BASE_PRODUCTION_URL = "https://checkout.dlocalgo.com/validate/subscription"

    DEFAULT_SUPPORTED_COUNTRIES = %w[UY AR CL BO BR CO CR EC GT ID MX MY PE PY].freeze
    CURRENCY_FOR_COUNTRY = { UY: "UYU", AR: "ARS", CL: "CLP", BO: "BOB", BR: "BRL",
                             CO: "COP", CR: "CRC", EC: "USD", GT: "GTQ", ID: "IDR", MX: "MXN",
                             MY: "MYR", PE: "PEN", PY: "PYG" }.freeze

    def currency_for_country(country)
      CURRENCY_FOR_COUNTRY[country.to_sym]
    end

    private

    def api_key
      @api_key ||= DlocalGo.api_key
    end

    def api_secret
      @api_secret ||= DlocalGo.api_secret
    end

    def base_url
      @base_url ||= DlocalGo.environment == "production" ? PRODUCTION_URL : SANDBOX_URL
    end

    def subscription_base_url
      @subscription_base_url ||= DlocalGo.environment == "production" ? SUBSCRIPTION_BASE_PRODUCTION_URL : SUBSCRIPTION_BASE_SANDBOX_URL
    end

    def supported_countries
      @supported_countries ||= DlocalGo.supported_countries || DEFAULT_SUPPORTED_COUNTRIES
    end
  end
end
