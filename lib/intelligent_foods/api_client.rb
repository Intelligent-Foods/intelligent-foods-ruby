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
      initialize_request
      assign_request_headers
      assign_request_body
      perform_request
      extract_access_token
      nil
    end

    protected

    attr_reader :encoded_token, :request, :response, :uri

    def initialize_request
      @uri = URI("#{IntelligentFoods.base_auth_url}/oauth2/token")
      @request = Net::HTTP::Post.new(uri)
    end

    def assign_request_headers
      request["content-type"] = "application/x-www-form-urlencoded"
      request["Authorization"] = "Basic #{encoded_token}"
    end

    def assign_request_body
      request.set_form_data("grant_type" => "client_credentials")
    end

    def perform_request
      @response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        response = http.request(request)
        JSON.parse(response.body, symbolize_names: true)
      end
    end

    def extract_access_token
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
