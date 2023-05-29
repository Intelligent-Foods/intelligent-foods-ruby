# frozen_string_literal: true

module IntelligentFoods
  class ApiClient
    attr_reader :id, :secret, :access_token

    def initialize(id: nil, secret: nil, client: nil)
      @id = id
      @secret = secret
      @client = client || Net::HTTP
    end

    def authenticate!
      uri = URI("#{IntelligentFoods.base_auth_url}/oauth2/token")
      request = Net::HTTP::Post.new(uri)
      request["content-type"] = "application/x-www-form-urlencoded"
      body = { "grant_type" => "client_credentials" }
      authorization = IntelligentFoods::Authorization::Basic.
                      factory(client_id: id, client_secret: secret)
      response = execute_request(request: request, uri: uri, body: body,
                                 authorization: authorization)
      handle_authentication_response(response: response.data)
      self
    end

    def execute_request(request:, uri:, body: nil,
                        authorization: default_authorization)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request["Authorization"] = authorization.header
        assign_body request: request, body: body
        response = http.request(request)
        OpenStruct.new(data: JSON.parse(response.body, symbolize_names: true),
                       success?: response.code.to_i < 400)
      end
    end

    protected

    attr_reader :encoded_token, :request, :response, :uri

    def assign_body(request:, body:)
      return if body.nil?

      request.set_form_data(body)
    end

    def handle_authentication_response(response:)
      if response_has_errors?(response)
        handle_errors(response)
      else
        @access_token = response[:access_token]
      end
    end

    def response_has_errors?(response)
      response.has_key?(:error)
    end

    def handle_errors(response)
      error = response[:error]
      fail IntelligentFoods::Error.new(error)
    end

    def default_authorization
      IntelligentFoods::Authorization::Bearer.new(token: access_token)
    end
  end
end
