# frozen_string_literal: true

RSpec.describe IntelligentFoods::ApiClient do
  describe "#authenticate!" do
    it "sets the access token" do
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      access_token = "accesstoken"
      stub_authentication access_token: access_token

      client.authenticate!

      expect(client.access_token).to eq(access_token)
    end

    context "there is an error with the request" do
      it "raises an error" do
        response = error_response(message: "Could not perform request")
        stub_api_response response: response
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

        expect {
          client.authenticate!
        }.to raise_error("Could not perform request")
      end
    end
  end

  describe "#execute_request" do
    it "makes the request" do
      request = build_stubbed_post
      http_client = double
      allow(http_client).to receive(:request)
      stub_api_response http: http_client
      uri = URI("https://example.com")
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

      client.execute_request(request: request, uri: uri)

      expect(http_client).to have_received(:request).with(request).once
    end

    it "parses the response body as JSON" do
      request = build_stubbed_post
      http_client = double
      response = OpenStruct.new(code: 200)
      stub_api_response response: response, http: http_client
      uri = URI("https://example.com")
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      allow(JSON).to receive(:parse)

      client.execute_request(request: request, uri: uri)

      expect(JSON).to have_received(:parse)
    end

    context "the response code is 204" do
      it "does not attempt to parse to response body as JSON" do
        request = build_stubbed_post
        http_client = double
        response = OpenStruct.new(code: 204)
        stub_api_response response: response, http: http_client
        uri = URI("https://example.com")
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
        allow(JSON).to receive(:parse)

        client.execute_request(request: request, uri: uri)

        expect(JSON).not_to have_received(:parse)
      end
    end

    context "the response code is 301" do
      it "does not attempt to parse to response body as JSON" do
        request = build_stubbed_post
        http_client = double
        response = OpenStruct.new(code: 301)
        stub_api_response response: response, http: http_client
        uri = URI("https://example.com")
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
        allow(JSON).to receive(:parse)

        client.execute_request(request: request, uri: uri)

        expect(JSON).not_to have_received(:parse)
      end
    end

    context "the response code is 401" do
      it "raises a IntelligentFoods::AuthenticationError" do
        request = build_stubbed_post
        http_client = double
        response = OpenStruct.new(code: 401)
        stub_api_response response: response, http: http_client
        uri = URI("https://example.com")
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

        expect {
          client.execute_request(request: request, uri: uri)
        }.to raise_error(IntelligentFoods::AuthenticationError)
      end

      it "is not authenticated" do
        request = build_stubbed_post
        http_client = double
        response = OpenStruct.new(code: 401)
        stub_api_response response: response, http: http_client
        uri = URI("https://example.com")
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

        begin
          client.execute_request(request: request, uri: uri)
        rescue IntelligentFoods::AuthenticationError
          expect(client).not_to be_authenticated
        end
      end
    end

    describe "#authenticated?" do
      it "is not authenticated" do
        client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

        expect(client).not_to be_authenticated
      end

      context "the client has been authenticated" do
        it "is authenticated" do
          stub_authentication
          client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

          client.authenticate!

          expect(client).to be_authenticated
        end
      end
    end
  end
end
