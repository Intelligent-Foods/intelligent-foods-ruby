# frozen_string_literal: true

module IntelligentFoods
  class ApiClient
    attr_reader :id, :secret, :access_token

    def initialize(id: nil, secret: nil, client: nil)
      @id = id
      @secret = secret
      @client = client || Net::HTTP
      @encoded_token = Base64.strict_encode64("#{id}:#{secret}")
    end

    def authenticate!
      uri = URI("#{IntelligentFoods.base_auth_url}/oauth2/token")
      request = Net::HTTP::Post.new(uri)
      request["content-type"] = "application/x-www-form-urlencoded"
      body = { "grant_type" => "client_credentials" }
      response = execute_request(request: request, uri: uri, body: body)
      extract_access_token response: response.data
      self
    end

    def execute_request(request:, uri:, body: nil)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request["Authorization"] = "Basic #{encoded_token}"
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

    def extract_access_token(response:)
      if response.has_key? :errors
        handle_errors response[:errors]
      else
        @access_token = response[:access_token]
      end
    end

    def handle_errors(errors)
      fail IntelligentFoods::Error.new(errors.first)
    end
  end
end
