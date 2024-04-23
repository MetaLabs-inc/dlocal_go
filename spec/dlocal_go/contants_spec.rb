# frozen_string_literal: true

class ConstantsTestClass
  include DlocalGo::Constants
end

RSpec.describe DlocalGo::Constants do
  subject { ConstantsTestClass.new }

  describe "included constants" do
    it "includes the expected constants" do
      expect(subject.class.constants).to include(
        :SANDBOX_URL,
        :PRODUCTION_URL,
        :SUBSCRIPTION_BASE_SANDBOX_URL,
        :SUBSCRIPTION_BASE_PRODUCTION_URL,
        :DEFAULT_SUPPORTED_COUNTRIES,
        :CURRENCY_FOR_COUNTRY
      )
    end
  end

  describe "#currency_for_country" do
    it "returns the currency for a given country" do
      expect(subject.currency_for_country("UY")).to eq("UYU")
      expect(subject.currency_for_country("AR")).to eq("ARS")
      expect(subject.currency_for_country("CL")).to eq("CLP")
      expect(subject.currency_for_country("BO")).to eq("BOB")
      expect(subject.currency_for_country("BR")).to eq("BRL")
      expect(subject.currency_for_country("CO")).to eq("COP")
      expect(subject.currency_for_country("CR")).to eq("CRC")
      expect(subject.currency_for_country("EC")).to eq("USD")
      expect(subject.currency_for_country("GT")).to eq("GTQ")
      expect(subject.currency_for_country("ID")).to eq("IDR")
      expect(subject.currency_for_country("MX")).to eq("MXN")
      expect(subject.currency_for_country("MY")).to eq("MYR")
      expect(subject.currency_for_country("PE")).to eq("PEN")
      expect(subject.currency_for_country("PY")).to eq("PYG")
    end
  end

  describe "private methods" do
    describe "#api_key" do
      before(:each) do
        DlocalGo.setup { |config| config.api_key = "api_key_sample" }
      end

      it "returns the configured api key" do
        expect(subject.send(:api_key)).to eq("api_key_sample")
      end
    end

    describe "#api_secret" do
      before(:each) do
        DlocalGo.setup { |config| config.api_secret = "api_secret_sample" }
      end

      it "returns the configured api secret" do
        expect(subject.send(:api_secret).to_s).to eq("api_secret_sample")
      end
    end

    describe "#base_url" do
      context "when environment is production" do
        before(:each) do
          DlocalGo.setup { |config| config.environment = "production" }
        end

        it "returns the production url" do
          expect(subject.send(:base_url)).to eq(DlocalGo::Constants::PRODUCTION_URL)
        end
      end

      context "when environment is sandbox" do
        before(:each) do
          DlocalGo.setup { |config| config.environment = "sandbox" }
        end

        it "returns the sandbox url" do
          expect(subject.send(:base_url)).to eq(DlocalGo::Constants::SANDBOX_URL)
        end
      end
    end

    describe "#subscription_base_url" do
      context "when environment is production" do
        before(:each) do
          DlocalGo.setup { |config| config.environment = "production" }
        end

        it "returns the production url" do
          expect(subject.send(:subscription_base_url)).to eq(DlocalGo::Constants::SUBSCRIPTION_BASE_PRODUCTION_URL)
        end
      end

      context "when environment is sandbox" do
        before(:each) do
          DlocalGo.setup { |config| config.environment = "sandbox" }
        end

        it "returns the sandbox url" do
          expect(subject.send(:subscription_base_url)).to eq(DlocalGo::Constants::SUBSCRIPTION_BASE_SANDBOX_URL)
        end
      end
    end

    describe "#supported_countries" do
      context "when supported countries are configured" do
        before(:each) do
          DlocalGo.setup { |config| config.supported_countries = %w[UY AR] }
        end

        it "returns the configured supported countries" do
          expect(subject.send(:supported_countries)).to match(%w[UY AR])
        end
      end

      context "when supported countries are not configured" do
        before(:each) do
          DlocalGo.setup { |config| config.supported_countries = nil }
        end

        it "returns the default supported countries" do
          expect(subject.send(:supported_countries)).to match(DlocalGo::Constants::DEFAULT_SUPPORTED_COUNTRIES)
        end
      end
    end
  end
end
