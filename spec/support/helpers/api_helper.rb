module ApiHelper
  def authentication_response(access_token:)
    build_response body: { access_token: access_token }
  end

  def error_response(message: "Unknown error")
    build_response body: { errors: [message] }
  end

  def stub_authentication(access_token: "indifferenttoken")
    response = authentication_response(access_token: access_token)
    stub_api_response response: response
  end

  def stub_api_response(response: OpenStruct.new(body: "{}"), http: double)
    allow(Net::HTTP).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(response)
  end

  def build_stubbed_post(url: "example.com")
    request = Net::HTTP::Post.new(url)
    allow(Net::HTTP::Post).to receive(:new).and_return(request)
    request
  end

  def build_response(body: {}, http_status_code: 200)
    OpenStruct.new(body: JSON.generate(body), code: http_status_code)
  end

  def build_encoded_token(id:, secret:)
    Base64.strict_encode64("#{id}:#{secret}")
  end
end
