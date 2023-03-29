# frozen_string_literal: true

RSpec.describe IntelligentFoods::Menu do
  describe ".all" do
    it "returns the menus" do
      menu_ids = ["2023-03-12"]
      response = build_response(body: menu_ids)
      stub_api_response response: response

      result = IntelligentFoods::Menu.all

      expect(result.map(&:id)).to eq(menu_ids)
    end

    context "the response code is not 200" do
      it "returns an empty array" do
        body = { errors: ["Could not perform request"] }
        response = build_response(body: body, http_status_code: 400)
        stub_api_response response: response

        result = IntelligentFoods::Menu.all

        expect(result).to be_empty
      end
    end
  end
end
