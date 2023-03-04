# frozen_string_literal: true

RSpec.describe DlocalGo do
  it "has a version number" do
    expect(DlocalGo::VERSION).not_to be nil
  end

  context "setup" do
    it "responds to setup and corresponding configurations" do
      expect(DlocalGo).to respond_to(:setup)
      expect(DlocalGo).to respond_to(:api_key, :api_key=, :api_secret, :api_secret=, :environment, :environment=,
                                     :supported_countries, :supported_countries=)
    end

    it "assigns the attributes correctly after setup" do
      api_key = "api_key_sample"
      api_secret = "api_secret_sample"
      environment = "production"
      supported_countries = %w[UY AR]

      DlocalGo.setup do |config|
        config.api_key = api_key
        config.api_secret = api_secret
        config.environment = environment
        config.supported_countries = supported_countries
      end

      expect(DlocalGo.api_key).to eq(api_key)
      expect(DlocalGo.api_secret).to eq(api_secret)
      expect(DlocalGo.environment).to eq(environment)
      expect(DlocalGo.supported_countries).to eq(supported_countries)
    end
  end
end
