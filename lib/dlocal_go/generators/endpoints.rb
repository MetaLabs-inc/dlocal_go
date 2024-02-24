require "http"

require_relative "constants"

require_relative "../responses/array"

module DlocalGo
  module Generators
    module Endpoints
      include Constants

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def subscription_base_url(token:, email: nil)
          base_url = DlocalGo.environment == "production" ? DlocalGo::Generators::Endpoints::SUBSCRIPTION_BASE_PRODUCTION_URL : DlocalGo::Generators::Endpoints::SUBSCRIPTION_BASE_SANDBOX_URL
          email.present? ? "#{base_url}#{token}?email=#{email}" : "#{base_url}#{token}"
        end

        def generate_endpoint(method, uri:, verb:, dto:, array: false)
          define_method(method) do |params = {}|
            raise DlocalGo::Error, "Unsupported country" if params[:country] && !supported_countries.include?(params[:country])

            response = call_api(verb, uri, params)
            raise DlocalGo::Error, "Error #{method} - #{uri}: #{response.parse}" unless response.status.success?

            parse_response(response, dto, array)
          end
        end
      end

      def call_api(http_method, uri, params)
        needs_body = %i[post put patch].include?(http_method)

        if needs_body
          HTTP.auth(auth_header).headers(json_content_type).send(http_method, endpoint_url(parse_uri(uri, params)), json: params)
        else
          HTTP.auth(auth_header).headers(json_content_type).send(http_method, endpoint_url(parse_uri(uri, params)))
        end
      end

      def parse_response(response, dto, array)
        if array
          DlocalGo::Responses::Array.new(OpenStruct.new(response.parse), dto)
        else
          dto.new(OpenStruct.new(response.parse))
        end
      end

      def parse_uri(uri, params)
        parsed_uri = uri
        query_params = params[:query_params] || {}

        params.each do |key, value|
          next if key == :query_params
          parsed_uri = parsed_uri.gsub(":#{key}", value.to_s)
        end

        "#{parsed_uri}?#{query_params.to_query}"
      end

      def auth_header
        "Bearer #{api_key}:#{api_secret}"
      end

      def json_content_type
        { 'content-type': "application/json" }
      end

      def endpoint_url(endpoint_url)
        "#{base_url}#{endpoint_url}"
      end

      def api_key
        @api_key ||= DlocalGo.api_key
      end

      def api_secret
        @api_secret ||= DlocalGo.api_secret
      end

      def base_url
        @base_url ||= DlocalGo.environment == "production" ? PRODUCTION_URL : SANDBOX_URL
      end

      def supported_countries
        @supported_countries ||= DlocalGo.supported_countries || DEFAULT_SUPPORTED_COUNTRIES
      end
    end
  end
end