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

  describe ".find" do
    it "returns the menu" do
      menu_id = "2023-01-01"
      body = build_menu_response(menu_id: menu_id)
      response = build_response(body: body)
      stub_api_response response: response

      result = IntelligentFoods::Menu.find(menu_id)

      expect(result.id).to eq(menu_id)
    end

    it "assigns correct number of items" do
      menu_id = "2023-01-01"
      expected_items_count = 2
      menu_items = stub_menu_items(number_of_items: expected_items_count)
      body = build_menu_response(menu_id: menu_id, menu_items: menu_items)
      response = build_response(body: body)
      stub_api_response response: response
      menu = IntelligentFoods::Menu.find(menu_id)

      result = menu.items.size

      expect(result).to eq(expected_items_count)
    end

    context "the id does not match a menu" do
      it "raises a IntelligentFoods::MenuNotFound error" do
        menu_id = "2023-01-01"
        response = error_response(message: "Menu not found",
                                  http_status_code: 400)
        stub_api_response response: response

        expect {
          IntelligentFoods::Menu.find(menu_id)
        }.to raise_error(IntelligentFoods::MenuNotFoundError)
      end
    end
  end
end
