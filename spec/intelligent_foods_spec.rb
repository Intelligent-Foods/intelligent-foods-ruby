# frozen_string_literal: true

RSpec.describe IntelligentFoods do
  it "has a version number" do
    expect(IntelligentFoods::VERSION).not_to be_nil
  end

  describe "#configure" do
    it "returns a new client with new attributes" do
      configure_client(id: "abc123", secret: "xyz890")

      IntelligentFoods.configure do |config|
        config.client_id = "id123"
        config.client_secret = "secret123"
      end

      expect(IntelligentFoods.client_id).to eq("id123")
    end

    it "sets the client ID" do
      IntelligentFoods.configure do |config|
        config.client_id = "abc"
      end

      expect(IntelligentFoods.client_id).to eq("abc")
    end

    it "sets the client secret" do
      IntelligentFoods.configure do |config|
        config.client_secret = "abc"
      end

      expect(IntelligentFoods.client_secret).to eq("abc")
    end

    it "sets the environment" do
      IntelligentFoods.configure do |config|
        config.environment = "preview"
      end

      expect(IntelligentFoods.environment).to eq("preview")
    end
  end

  describe "#base_url" do
    context "environment is staging" do
      it "returns the correct url" do
        IntelligentFoods.configure do |config|
          config.environment = "staging"
        end
        staging_url = "https://api.sunbasket.dev/partner/v1"

        expect(IntelligentFoods.base_url).to eq(staging_url)
      end
    end

    context "environment is production" do
      it "returns the correct url" do
        IntelligentFoods.configure do |config|
          config.environment = "production"
        end
        production_url = "https://api.sunbasket.com/partner/v1"

        expect(IntelligentFoods.base_url).to eq(production_url)
      end
    end

    context "environment is not any of the above" do
      it "defaults to the dev url" do
        IntelligentFoods.configure do |config|
          config.environment = "asdf"
        end
        preview_url = "https://api.sunbasket.dev/partner/v1"

        expect(IntelligentFoods.base_url).to eq(preview_url)
      end
    end
  end

  describe "#base_auth_url" do
    context "environment is staging" do
      it "returns the correct url" do
        IntelligentFoods.configure do |config|
          config.environment = "staging"
        end
        staging_url =
          "https://api.sunbasket.dev/partner/v1/token"

        expect(IntelligentFoods.base_auth_url).to eq(staging_url)
      end
    end

    context "environment is production" do
      it "returns the correct url" do
        IntelligentFoods.configure do |config|
          config.environment = "production"
        end
        production_url =
          "https://api.sunbasket.com/partner/v1/token"

        expect(IntelligentFoods.base_auth_url).to eq(production_url)
      end
    end

    context "environment is not any of the above" do
      it "defaults to the dev url" do
        IntelligentFoods.configure do |config|
          config.environment = "asdf"
        end
        preview_url =
          "https://api.sunbasket.dev/partner/v1/token"

        expect(IntelligentFoods.base_auth_url).to eq(preview_url)
      end
    end
  end

  describe "#client" do
    it "returns an instance of the api client" do
      result = configure_client(id: "abc123", secret: "xyz890")

      expect(result.id).to eq("abc123")
      expect(result.secret).to eq("xyz890")
    end
  end

  def configure_client(id:, secret:)
    IntelligentFoods.configure do |config|
      config.client_id = id
      config.client_secret = secret
    end
    IntelligentFoods.client
  end

end
