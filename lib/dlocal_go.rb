# frozen_string_literal: true

require_relative "dlocal_go/version"
require_relative "dlocal_go/errors"
require_relative "dlocal_go/client"

# Main module for Dlocal Go, it provides a way to configure the gem and imports the client
module DlocalGo
  def self.setup
    yield self
  end

  def self.clear_setup
    self.api_key = nil
    self.api_secret = nil
    self.environment = nil
    self.supported_countries = nil
  end

  class << self
    attr_accessor :api_key, :api_secret, :environment, :supported_countries
  end

  self.api_key = nil
  self.api_secret = nil
  self.environment = nil
  self.supported_countries = nil
end
