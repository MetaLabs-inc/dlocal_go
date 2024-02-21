# frozen_string_literal: true

module DlocalGo
  module Responses
    # Wrapper for Dlocal Go array responses
    class Array
      RESPONSE_ATTRIBUTES = %i[data total_elements total_pages page number_of_elements size].freeze

      attr_reader(*RESPONSE_ATTRIBUTES)

      def initialize(response, data_class)
        (RESPONSE_ATTRIBUTES - %i[data]).each do |attribute|
          instance_variable_set("@#{attribute}", response.send(attribute) || response.send(attribute.to_s.camelize(:lower)))
        end

        @data = response.data.map { |data| data_class.new(OpenStruct.new(data)) }
      end
    end
  end
end
