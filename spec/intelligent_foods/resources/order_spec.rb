# frozen_string_literal: true

RSpec.describe IntelligentFoods::Order do
  describe "#create!" do
    it "creates the order" do
      recipient = build(:recipient)
      menu = build(:menu, id: "2023-01-01")
      order_item = build(:order_item)
      callback_url = "https://api.domain.com/callback"
      order = IntelligentFoods::Order.new(menu: menu,
                                          recipient: recipient,
                                          delivery_date: "2023-01-07",
                                          items: [order_item],
                                          external_id: "1337",
                                          callback_url: callback_url)
      body = build_order_response
      response = build_response(body: body)
      stub_api_response response: response

      result = order.create!

      expect(result).to be_accepted
    end

    it "assigns the recipient in the request body" do
      recipient = build(:recipient)
      ship_to = IntelligentFoods::RecipientSerializer.new(recipient).to_json
      menu = build(:menu, id: "2023-01-01")
      order = IntelligentFoods::Order.new(recipient: recipient, menu: menu)
      body = build_order_response
      response = build_response(body: body)
      stub_api_response response: response

      result = order.request_body

      expect(result[:ship_to]).to eq(ship_to)
    end

    context "a recipient address value is an empty string" do
      it "excludes it from the request body" do
        recipient = build(:recipient, street2: "")
        menu = build(:menu, id: "2023-01-01")
        order = IntelligentFoods::Order.new(recipient: recipient, menu: menu)
        body = build_order_response
        response = build_response(body: body)
        stub_api_response response: response

        result = order.request_body[:ship_to]

        expect(result).not_to have_key(:street2)
      end
    end

    it "assigns the order items in the request body" do
      recipient = build(:recipient)
      menu = build(:menu, id: "2023-01-01")
      order_item = build(:order_item, quantity: 2)
      order_item_serialized = IntelligentFoods::OrderItemSerializer.
                              new(order_item).
                              to_json
      order = IntelligentFoods::Order.new(recipient: recipient, menu: menu,
                                          items: [order_item])
      body = build_order_response
      response = build_response(body: body)
      stub_api_response response: response
      expected_output = [order_item_serialized]

      result = order.request_body

      expect(result[:items]).to eq(expected_output)
    end

    it "assigns the reference id as a string in the request body" do
      recipient = build(:recipient)
      menu = build(:menu, id: "2023-01-01")
      order_item = build(:order_item, quantity: 2)
      order = IntelligentFoods::Order.new(menu: menu,
                                          recipient: recipient,
                                          items: [order_item],
                                          external_id: 1234)
      body = build_order_response
      response = build_response(body: body)
      stub_api_response response: response

      result = order.request_body

      expect(result[:reference_id]).to be_an_instance_of(String)
    end

    context "the response code is not 201" do
      it "raises a OrderNotCreatedError" do
        recipient = build(:recipient)
        menu = build(:menu, id: "2023-01-01")
        order = IntelligentFoods::Order.new(recipient: recipient, menu: menu)
        response = error_response(message: "Order Not Created",
                                  http_status_code: 400)
        stub_api_response response: response

        expect {
          order.create!
        }.to raise_error(IntelligentFoods::OrderNotCreatedError)
      end

      it "marks the order as invalid" do
        recipient = build(:recipient)
        menu = build(:menu, id: "2023-01-01")
        order = IntelligentFoods::Order.new(recipient: recipient, menu: menu)
        response = error_response(message: "Order Not Created",
                                  http_status_code: 400)
        stub_api_response response: response

        begin
          order.create!
        rescue IntelligentFoods::OrderNotCreatedError
          # noop
        end

        expect(order).not_to be_valid
      end
    end

    context "validation options are provided" do
      it "assigns the validation options in the request body" do
        recipient = build(:recipient)
        menu = build(:menu, id: "2023-01-01")
        order_item = build(:order_item, quantity: 2)
        order = IntelligentFoods::Order.new(recipient: recipient, menu: menu,
                                            items: [order_item],
                                            skip_temperature_check: true)
        body = build_order_response
        response = build_response(body: body)
        stub_api_response response: response
        expected_output = {
          skip_temperature_check: true, skip_address_check: false
        }

        result = order.request_body

        expect(result[:validation_options]).to eq(expected_output)
      end
    end
  end

  describe "#cancel!" do
    it "cancels the order" do
      order = IntelligentFoods::Order.new(id: 1)
      response = build_response(body: nil, http_status_code: 204)
      stub_api_response response: response

      result = order.cancel!

      expect(result).to be_cancelled
    end

    context "the response code is not 204" do
      it "raises a OrderNotCancelledError" do
        order = IntelligentFoods::Order.new(id: 1)
        response = error_response(message: "Order Not Found",
                                  http_status_code: 400)
        stub_api_response response: response

        expect {
          order.cancel!
        }.to raise_error(IntelligentFoods::OrderNotCancelledError)
      end

      it "marks the order as not valid" do
        order = IntelligentFoods::Order.new(id: 1)
        response = error_response(message: "Order Not Found",
                                  http_status_code: 400)
        stub_api_response response: response

        begin
          order.cancel!
        rescue IntelligentFoods::OrderNotCancelledError
          # noop
        end

        expect(order).not_to be_valid
      end
    end
  end
end
