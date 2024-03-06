# frozen_string_literal: true

RSpec.describe IntelligentFoods::Authentication do
  describe "#request" do
    it "sets the authorization basic header" do
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      auth = IntelligentFoods::Authentication.new(client: client)
      header = "Basic #{build_encoded_token(id: "id", secret: "secret")}"

      request = auth.request

      expect(request["Authorization"]).to eq(header)
    end

    it "sets the content type header" do
      client = IntelligentFoods::ApiClient.new(id: "id", secret: "secret")
      auth = IntelligentFoods::Authentication.new(client: client)
      content_type = "application/x-www-form-urlencoded"

      request = auth.request

      expect(request["content-type"]).to eq(content_type)
    end
  end

  describe "#uri" do
    it "returns the authentication uri" do
      auth = IntelligentFoods::Authentication.new(client: double)
      uri = URI("#{IntelligentFoods.base_auth_url}/oauth2/token")

      result = auth.uri

      expect(result).to eq(uri)
    end

  end

  describe "#body" do
    it "returns the grant type" do
      auth = IntelligentFoods::Authentication.new(client: double)

      result = auth.body

      expect(result).to eq({ "grant_type" => "client_credentials" })
    end
  end
end
