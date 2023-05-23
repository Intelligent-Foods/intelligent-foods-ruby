module ApiHelper
  MENU_API_RESPONSE = "spec/support/fixtures/menu_response.json".freeze

  def authentication_response(access_token:)
    build_response body: { access_token: access_token }
  end

  def error_response(message: "Unknown error")
    build_response body: { error: message }
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

  def read_menu_api_response
    JSON.parse(File.read(MENU_API_RESPONSE), symbolize_names: true)
  end

  def build_menu_response(menu_id: "2023-01-01", menu_items: [])
    stubbed_response = read_menu_api_response
    stubbed_response[:id] = menu_id
    stubbed_response[:items] = menu_items
    stubbed_response
  end

  def stubbed_menu_items
    response = read_menu_api_response
    response[:items]
  end

  def stub_menu_items(number_of_items: nil)
    response = stubbed_menu_items
    however_many_items = number_of_items || response.size
    response.first(however_many_items)
  end
end
