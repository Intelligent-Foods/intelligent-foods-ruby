# frozen_string_literal: true

module IntelligentFoods
  class ApiClient
    attr_accessor :access_token
    attr_reader :id, :secret

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

    def build_patch_request(uri:, body: nil)
      build_request_with_body(uri: uri, body: body,
                              http_method: Net::HTTP::Patch)
    end

    def build_post_request(uri:, body: nil)
      build_request_with_body(uri: uri, body: body,
                              http_method: Net::HTTP::Post)
    end

    def build_request_with_body(uri:, body:, http_method:)
      request = http_method.new(uri)
      request["content-type"] = "application/json"
      unless body.nil?
        request.body = body.to_json
      end
      request
    end

    def execute_request(request:, uri:, body: nil,
                        authorization: default_authorization)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request["Authorization"] = authorization.header
        assign_body request: request, body: body
        response = http.request(request)
        handle_response(response: response)
      end
    end

    def authenticated?
      access_token.present?
    end

    protected

    attr_reader :encoded_token, :request, :response, :uri

    def handle_response(response:)
      if authentication_failed?(response.code)
        handle_authentication_error!
      else
        body = parse_response_body(response)
        OpenStruct.new(data: body, success?: request_successful?(response.code))
      end
    end

    def handle_authentication_error!
      @access_token = nil
      raise AuthenticationError.new(status: 401,
                                    title: "Authentication Failed")
    end

    def parse_response_body(response)
      return {} if empty_response?(response.code)
      return {} if redirection?(response.code)

      JSON.parse(response.body, symbolize_names: true)
    end

    def empty_response?(response_code)
      response_code.to_i == 204
    end

    def redirection?(response_code)
      response_code.to_i.between?(300, 399)
    end

    def request_successful?(response_code)
      response_code.to_i.between?(200, 299)
    end

    def authentication_failed?(response_code)
      response_code.to_i == 401
    end

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
