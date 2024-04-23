# frozen_string_literal: true

class TestClient
  include DlocalGo::EndpointGenerator

  class TestDTO < DlocalGo::Responses::Base
    has_attributes %i[first_attribute second_attribute]
  end

  endpoint :new_endpoint, uri: "/v1/new_endpoint", verb: :get, dto_class: TestDTO
  endpoint :another_endpoint, uri: "/v1/another_endpoint/:my_id", verb: :get, dto_class: TestDTO
end

RSpec.describe DlocalGo::EndpointGenerator do
  subject(:client) { TestClient.new }

  it "includes the DlocalGo::Constants module when including the DlocalGo::EndpointGenerator" do
    expect(client.class.included_modules).to include(DlocalGo::Constants)
  end

  describe "#endpoint" do
    let(:response_body) { { first_attribute: "first", second_attribute: "second" } }

    before(:each) do
      DlocalGo.setup do |config|
        config.api_key = "api_key_sample"
        config.api_secret = "api_secret_sample"
        config.environment = "sandbox"
      end
    end

    it "defines a method based on the endpoint call" do
      expect(client).to respond_to(:new_endpoint)
      expect(client).to respond_to(:another_endpoint)
    end

    context "calling the endpoint" do
      before(:each) do
        stub_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/new_endpoint")
          .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })
      end

      it "calls to the expected endpoint when calling the method and returns the desired DTO" do
        result = client.new_endpoint
        expect(a_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/new_endpoint")).to have_been_made
        expect(result).to be_a(TestClient::TestDTO)
      end
    end

    context "calling the endpoint with a query param" do
      let(:query_params) { { page: 2 } }

      before(:each) do
        stub_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/new_endpoint?page=2")
          .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })
      end

      it "calls to the expected endpoint with the query params and returns the expected DTO" do
        result = client.new_endpoint(query_params: query_params)
        expect(a_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/new_endpoint?page=2")).to have_been_made
        expect(result).to be_a(TestClient::TestDTO)
      end
    end

    context "when calling an endpoint with path variables" do
      before(:each) do
        stub_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/another_endpoint/123")
          .to_return(body: JSON(response_body).to_s, headers: { "Content-Type" => "application/json" })
      end

      it "calls to the expected endpoint with the path variables and returns the expected DTO" do
        result = client.another_endpoint(my_id: "123")
        expect(a_request(:get, "#{DlocalGo::Constants::SANDBOX_URL}/v1/another_endpoint/123")).to have_been_made
        expect(result).to be_a(TestClient::TestDTO)
      end
    end
  end
end
