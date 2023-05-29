# frozen_string_literal: true

module IntelligentFoods
  class Authorization::Basic < Authorization
    def header
      "Basic #{token}"
    end

    def self.factory(client_id:, client_secret:)
      encoded_token = Base64.strict_encode64("#{client_id}:#{client_secret}")
      new(token: encoded_token)
    end
  end
end
