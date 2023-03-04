# frozen_string_literal: true

require_relative "responses/payment"
require_relative "responses/refund"

module DlocalGo
  # Client for Dlocal Go API
  class Client
    SANDBOX_URL = "https://api-sbx.dlocalgo.com"
    PRODUCTION_URL = "https://api.dlocalgo.com"
    DEFAULT_SUPPORTED_COUNTRIES = %w[UY AR CL BO BR CO CR EC GT ID MX MY PE PY].freeze
    CURRENCY_FOR_COUNTRY = { UY: "UYU", AR: "ARS", CL: "CLP", BO: "BOB", BR: "BRL",
                             CO: "COP", CR: "CRC", EC: "USD", GT: "GTQ", ID: "IDR", MX: "MXN",
                             MY: "MYR", PE: "PEN", PY: "PYG" }.freeze

    def initialize
      @api_key = DlocalGo.api_key
      @api_secret = DlocalGo.api_secret
      @base_url = DlocalGo.environment == "production" ? PRODUCTION_URL : SANDBOX_URL

      raise DlocalGo::Error, "Dlocal Go api key is not set" if @api_key.nil?
      raise DlocalGo::Error, "Dlocal Go api secret is not set" if @api_secret.nil?
    end

    def create_payment(params = {})
      raise DlocalGo::Error, "Unsupported country" unless supported_countries.include?(params[:country_code])

      uri = "/v1/payments"
      body = { amount: params[:amount], country: params[:country_code], notification_url: params[:notification_url],
               currency: params[:currency] || CURRENCY_FOR_COUNTRY[params[:country_code].to_sym],
               success_url: params[:success_url], back_url: params[:back_url] }

      response = HTTP.auth(auth_header).headers(json_content_type).post(endpoint_url(uri), json: body)

      raise DlocalGo::Error, "Error creating checkout #{response.parse}" unless response.status.success?

      DlocalGo::Responses::Payment.new(OpenStruct.new(response.parse))
    end

    def get_payment(payment_id)
      uri = "/v1/payments/#{payment_id}"
      response = HTTP.auth(auth_header).get(endpoint_url(uri))

      raise DlocalGo::Error, "Error getting payment: #{response.parse}" unless response.status.success?

      DlocalGo::Responses::Payment.new(OpenStruct.new(response.parse))
    end

    def create_refund(params = {})
      uri = "/v1/refunds"
      body = { payment_id: params[:payment_id], currency: params[:currency], amount: params[:amount],
               notification_url: params[:notification_url] }

      response = HTTP.auth(auth_header).headers(json_content_type).post(endpoint_url(uri), json: body)

      raise DlocalGo::Error, "Error creating refund: #{response.parse}" unless response.status.success?

      DlocalGo::Responses::Refund.new(OpenStruct.new(response.parse))
    end

    private

    def auth_header
      "Bearer #{@api_key}:#{@api_secret}"
    end

    def json_content_type
      { 'content-type': "application/json" }
    end

    def endpoint_url(endpoint_url)
      "#{@base_url}#{endpoint_url}"
    end

    def supported_countries
      DlocalGo.supported_countries || DEFAULT_SUPPORTED_COUNTRIES
    end
  end
end
