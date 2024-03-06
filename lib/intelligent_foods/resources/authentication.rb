# frozen_string_literal: true

module IntelligentFoods
  class Authentication
    def initialize(client:)
      @client = client
    end

    def request
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = basic_authorization.header
      request["content-type"] = "application/x-www-form-urlencoded"
      request.set_form_data(body)
      request
    end

    def uri
      URI("#{IntelligentFoods.base_auth_url}/oauth2/token")
    end

    def body
      { "grant_type" => "client_credentials" }
    end

    protected

    attr_reader :client

    def basic_authorization
      IntelligentFoods::Authorization::Basic.
        factory(client_id: client.id, client_secret: client.secret)
    end
  end
end
