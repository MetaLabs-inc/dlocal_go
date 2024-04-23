# frozen_string_literal: true

require_relative "response_parser"

module DlocalGo
  module Responses
    class Base
      include DlocalGo::Responses::ResponseParser
    end
  end
end
