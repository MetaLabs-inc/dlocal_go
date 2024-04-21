require_relative "base"

module DlocalGo
  module Responses
    # Wrapper for Dlocal Go array responses
    class Array < DlocalGo::Responses::Base
      has_array_data_attribute :data

      has_attributes %i[
        total_elements
        total_pages
        page
        number_of_elements
        size
      ]
    end
  end
end
