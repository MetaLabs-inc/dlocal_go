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

    it "sets base url to production if environment is production" do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "production"
        config.supported_countries = %w[UY AR]
      end

      expect(client.instance_variable_get(:@base_url)).to eq(DlocalGo::Client::PRODUCTION_URL)
    end

    it "sets base url to sandbox if environment is sandbox" do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
        config.supported_countries = %w[UY AR]
      end

      expect(client.instance_variable_get(:@base_url)).to eq(DlocalGo::Client::SANDBOX_URL)
    end
  end

  describe "#create_payment" do
    context "unsupported country" do
      it "raises an error if country is not in supported countries list configured beforehand" do
        DlocalGo.setup do |config|
          config.api_key = "api_key_sample"
          config.api_secret = "api_secret_sample"
          config.environment = "sandbox"
          config.supported_countries = %w[UY AR]
        end

        expect { client.create_payment({ country_code: "CL" }) }.to raise_error(DlocalGo::Error, "Unsupported country")
      end

      it "raises an error if country is not supported in the default ones" do
        DlocalGo.setup do |config|
          config.api_key = "api_key_sample"
          config.api_secret = "api_secret_sample"
          config.environment = "sandbox"
        end

        expect { client.create_payment({ country_code: "US" }) }.to raise_error(DlocalGo::Error, "Unsupported country")
      end
    end

    context "supported country" do
      before(:each) do
        DlocalGo.setup do |config|
          config.api_key = "api_key_sample"
          config.api_secret = "api_secret_sample"
          config.environment = "sandbox"
          config.supported_countries = %w[UY AR]
        end

        context "successful request" do
          let!(:params) do
            { country_code: "UY", currency: "USD", amount: 100, success_url: "https://success.url",
              back_url: "https://back.url", notification_url: "https://notification.url" }
          end
          let!(:response_body) do
            { id: "payment_id_sample", amount: 100, currency: "USD", country: "UY",
              created_date: "2020-01-01T00:00:00Z", status: "PENDING", order_id: "order_id_sample",
              success_url: "https://success.url", back_url: "https://back.url",
              redirect_url: "https://redirect.url", direct: false,
              merchant_checkout_token: "merchant_checkout_token_sample" }
          end

          it "returns expected payment response object" do
            stub_request(:post, "#{DlocalGo::Client::SANDBOX_URL}/v1/payments")
              .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })

            result = client.create_payment(params)
            expect(result).to be_a(DlocalGo::Responses::Payment)

            DlocalGo::Responses::Payment::RESPONSE_ATTRIBUTES.each do |attr|
              expect(result.send(attr)).to eq(response_body[attr])
            end
          end
        end

        context "unsuccessful request" do
          let!(:params) do
            { country_code: "UY", currency: "USD", amount: 100, success_url: "https://success.url",
              back_url: "https://back.url", notification_url: "https://notification.url" }
          end
          let!(:response_body) do
            { error: { code: "invalid_request", message: "Invalid request" } }
          end

          it "raises an error" do
            stub_request(:post, "#{DlocalGo::Client::SANDBOX_URL}/v1/payments")
              .to_return(body: JSON(response_body).to_s, status: 400, headers: { "Content-Type" => "application/json" })

            expect { client.create_payment(params) }.to raise_error(DlocalGo::Error)
          end
        end
      end
    end
  end

  describe "#get_payment" do
    before(:each) do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
        config.supported_countries = %w[UY AR]
      end
    end

    context "successful request" do
      let!(:payment_id) { "payment_id_sample" }
      let!(:response_body) do
        { id: "payment_id_sample", amount: 100, currency: "USD", country: "UY",
          created_date: "2020-01-01T00:00:00Z", status: "PENDING", order_id: "order_id_sample",
          success_url: "https://success.url", back_url: "https://back.url",
          redirect_url: "https://redirect.url", direct: false,
          merchant_checkout_token: "merchant_checkout_token_sample" }
      end

      it "returns expected payment response object" do
        stub_request(:get, "#{DlocalGo::Client::SANDBOX_URL}/v1/payments/#{payment_id}")
          .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })

        result = client.get_payment(payment_id)
        expect(result).to be_a(DlocalGo::Responses::Payment)

        DlocalGo::Responses::Payment::RESPONSE_ATTRIBUTES.each do |attr|
          expect(result.send(attr)).to eq(response_body[attr])
        end
      end
    end

    context "unsuccessful request" do
      let!(:payment_id) { "payment_id_sample" }
      let!(:response_body) do
        { error: { code: "invalid_request", message: "Invalid request" } }
      end

      it "raises an error" do
        stub_request(:get, "#{DlocalGo::Client::SANDBOX_URL}/v1/payments/#{payment_id}")
          .to_return(body: JSON(response_body).to_s, status: 400, headers: { "Content-Type" => "application/json" })

        expect { client.get_payment(payment_id) }.to raise_error(DlocalGo::Error)
      end
    end
  end

  describe "#create_refund" do
    before(:each) do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
        config.supported_countries = %w[UY AR]
      end
    end

    context "successful request" do
      let!(:params) { { payment_id: "payment_id_sample", amount: 100, reason: "reason_sample" } }
      let!(:response_body) do
        { id: "refund_id_sample", payment_id: "payment_id_sample", amount: 100, status: "PENDING" }
      end

      it "returns expected refund response object" do
        stub_request(:post, "#{DlocalGo::Client::SANDBOX_URL}/v1/refunds")
          .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })

        result = client.create_refund(params)
        expect(result).to be_a(DlocalGo::Responses::Refund)

        DlocalGo::Responses::Refund::RESPONSE_ATTRIBUTES.each do |attr|
          expect(result.send(attr)).to eq(response_body[attr])
        end
      end

      context "unsuccessful request" do
        let!(:params) { { payment_id: "payment_id_sample", amount: 100, reason: "reason_sample" } }
        let!(:response_body) do
          { error: { code: "invalid_request", message: "Invalid request" } }
        end

        it "raises an error" do
          stub_request(:post, "#{DlocalGo::Client::SANDBOX_URL}/v1/refunds")
            .to_return(body: JSON(response_body).to_s, status: 400, headers: { "Content-Type" => "application/json" })

          expect { client.create_refund(params) }.to raise_error(DlocalGo::Error)
        end
      end
    end
  end
end
