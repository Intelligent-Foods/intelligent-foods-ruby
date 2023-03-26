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

    it "sets the content type header" do
      stub_authentication
      request = build_stubbed_post
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      content_type = "application/x-www-form-urlencoded"

      client.authenticate!

      expect(request["content-type"]).to eq(content_type)
    end

    it "sets the authorization header" do
      stub_authentication
      request = build_stubbed_post
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      header = "Basic #{build_encoded_token(id: "id", secret: "secret")}"

      client.authenticate!

      expect(request["Authorization"]).to eq(header)
    end

    it "sets the request body" do
      stub_authentication
      request = build_stubbed_post
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")

      client.authenticate!

      expect(request.body).to eq("grant_type=client_credentials")
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
end
