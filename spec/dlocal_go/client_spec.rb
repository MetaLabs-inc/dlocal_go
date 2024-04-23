# frozen_string_literal: true

RSpec.describe DlocalGo::Client do
  subject(:client) { DlocalGo::Client.new }

  after(:each) do
    DlocalGo.clear_setup
  end

  describe "#initialize" do
    it "raises an error if api key is not set" do
      DlocalGo.setup do |config|
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
        config.supported_countries = %w[UY AR]
      end

      expect { client }.to raise_error(DlocalGo::Error, "Dlocal Go api key is not set")
    end

    it "raises an error if api secret is not set" do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.environment = "sandbox"
        config.supported_countries = %w[UY AR]
      end

      expect { client }.to raise_error(DlocalGo::Error, "Dlocal Go api secret is not set")
    end
  end

  describe "endpoints" do
    before(:each) do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
      end
    end

    let(:methods) do
      %i[
        create_payment get_payment create_refund get_refund
        create_recurring_payment get_recurring_payment get_all_recurring_payments
        create_subscription_plan update_subscription_plan get_all_subscription_plans get_subscription_plan
        get_subscriptions_by_plan get_all_executions_by_subscription get_subscription_execution
        cancel_plan cancel_subscription
      ]
    end

    it "defines the expected endpoints" do
      methods.each do |method|
        expect(client).to respond_to(method)
      end
    end
  end
end
