# frozen_string_literal: true

RSpec.describe IntelligentFoods::Menu do
  describe ".all" do
    it "performs the request" do
      stub_authentication
      http = stub_http_response

      IntelligentFoods::Menu.all

      expect(http).to have_received(:request).once
    end

    it "returns the menus" do
      stub_authentication
      menu_ids = ["2023-03-12"]
      stub_http_response(menu_ids: menu_ids)

      result = IntelligentFoods::Menu.all

      expect(result.first).to be_an_instance_of(IntelligentFoods::Menu)
    end

    context "the response code is not 200" do
      it "returns an empty array" do
        stub_authentication
        stub_http_response(error: true)

        result = IntelligentFoods::Menu.all

        expect(result).to be_empty
      end
    end
  end

  def stub_authentication
    client = double("client")
    allow(IntelligentFoods).to receive(:client).and_return(client)
    allow(client).to receive(:access_token).and_return("test_token")
  end

  def stub_http_response(menu_ids: [], error: false)
    stubbed_response_body = build_response_body(menu_ids: menu_ids,
                                                error: error)
    stubbed_response = OpenStruct.new(code: response_code(error),
                                      body: stubbed_response_body.to_json)
    http = double
    allow(Net::HTTP).to receive(:start).and_yield(http)
    allow(http).to receive(:request).and_return(stubbed_response)
    http
  end

  def response_code(error)
    return "401" if error
    "200"
  end

  def build_response_body(menu_ids:, error:)
    if error
      { errors: ["Could not perform request"] }
    else
      menu_ids
    end
  end
end
