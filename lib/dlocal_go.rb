# frozen_string_literal: true

require_relative "dlocal_go/version"
require_relative "dlocal_go/errors"
require_relative "dlocal_go/client"

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

  def self.api_key
    @@api_key
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_secret
    @@api_secret
  end

  def self.api_secret=(api_secret)
    @@api_secret = api_secret
  end

  def self.environment
    @@environment
  end

  def self.environment=(environment)
    @@environment = environment
  end

  def self.supported_countries
    @@supported_countries
  end

  def self.supported_countries=(supported_countries)
    @@supported_countries = supported_countries
  end

  self.api_key = nil
  self.api_secret = nil
  self.environment = nil
  self.supported_countries = nil
end
