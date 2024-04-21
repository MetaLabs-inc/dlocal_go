require "http"

require_relative "constants"
require_relative "responses/array"

module DlocalGo
  module EndpointGenerator
    include Constants

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def generate_endpoint(method, uri:, verb:, dto_class:)
        define_method(method) do |params = {}|
          raise DlocalGo::Error.new("Unsupported country") if params[:country].present? && supported_countries.exclude?(params[:country])

          response = call_api(verb, uri, params)
          parse_response(response, dto_class)
        end
      end
    end

    private

    def call_api(http_method, uri, params)
      parsed_uri, keys_to_remove = parse_uri(uri, params)
      url = endpoint_url(parsed_uri)
      args = [http_method, url]
      needs_body = %i[post put patch].include?(http_method)

      request_body = params.except(*keys_to_remove)
      args << { json: request_body } if needs_body

      HTTP.auth(auth_header).headers(json_content_type).send(*args)
    end

    # We grab the query_params from the params hash
    # We also grab the path variables from the params hash and replace them in the uri
    # We return the uri and the keys from the params hash that we used so we can remove them later and not include them in the json body
    def parse_uri(uri, params)
      parsed_uri = uri
      keys_to_remove = %i[query_params]
      query_params = params[:query_params] || {}

      params.each do |key, value|
        next unless uri.include?(":#{key}")

        parsed_uri = parsed_uri.gsub(":#{key}", value.to_s)
        keys_to_remove << key
      end

      ["#{parsed_uri}?#{query_params.to_query}", keys_to_remove]
    end

    def parse_response(response, dto_class)
      response_body = response.parse
      raise DlocalGo::Error.new(response_body["message"], error_code: response_body["code"]) unless response.status.success?

      parse_successful_response(response_body, dto_class)
    end

    def parse_successful_response(response_body, dto_class)
      struct = OpenStruct.new(response_body)
      array_response = response_body.dig("data").is_a?(Array)

      array_response ? DlocalGo::Responses::Array.new(struct, { data_class: dto_class }) : dto_class.new(struct)
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
  end
end