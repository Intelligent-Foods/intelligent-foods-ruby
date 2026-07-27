# frozen_string_literal: true

RSpec.describe Bls::Core::InventoryLevel do
  describe ".retrieve_all" do
    it "returns the product inventory levels" do
      body = build_inventory_levels_response
      response = build_response(body: body)
      stub_api_v1_authentication
      stub_api_response response: response
      product_id = "MP0527"

      result = Bls::Core::InventoryLevel.retrieve_all

      expect(result.map(&:sku)).to match_array(product_id)
    end
  end

  describe "#to_json" do
    it "returns a serialized inventory level" do
      level = Bls::Core::InventoryLevel.new(sku: "BLS123",
                                            date: "2026-01-01",
                                            distribution_center: "WEST_COAST",
                                            quantity: 100)
      serialized_level = {
        sku: "BLS123",
        date: "2026-01-01",
        distribution_center: "WEST_COAST",
        quantity: 100,
      }

      result = level.to_json

      expect(result).to eq(serialized_level)
    end
  end
end
