# frozen_string_literal: true

require "base64"
require "json"
require "net/http"
require "ostruct"

require "intelligent_foods/api_client"
require "intelligent_foods/resources/menu"
require "intelligent_foods/version"

module IntelligentFoods
  class Error < StandardError; end

  class << self
    attr_accessor :client_id, :client_secret, :environment

    def configure
      yield self
      configure_enviroment
    end

    def base_auth_url
      @base_auth_url = "https://#{auth_domain}.auth.us-west-2.amazoncognito.com"
    end

    def base_url
      @base_url = "https://api.#{domain}.com/partner/v1"
    end

    def client
      @client ||=
        IntelligentFoods::ApiClient.new(id: client_id, secret: client_secret)
    end

    protected

    attr_reader :domain, :auth_domain

    def configure_enviroment
      case environment
      when "production"
        @auth_domain = "sunbasket-partner"
        @domain = "sunbasket"
      when "staging"
        @auth_domain = "sunbasket-partner-staging"
        @domain = "sunbasket-staging"
      else
        @auth_domain = "sunbasket-partner-dev"
        @domain = "sunbasket-dev"
      end
    end

  end
end
