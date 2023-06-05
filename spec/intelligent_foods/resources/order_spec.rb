# frozen_string_literal: true

RSpec.describe IntelligentFoods::Order do
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
