# frozen_string_literal: true

RSpec.describe Bls::Core::Product do
  describe ".retrieve" do
    it "returns the product" do
      product_id = "MP0527"
      body = build_product_response(product_id: product_id)
      response = build_response(body: body)
      stub_api_v2_authentication
      stub_api_response response: response

      result = Bls::Core::Product.retrieve(product_id)

      expect(result.code).to eq(product_id)
    end
  end

  describe ".build_from_response" do
    it "creates a product using the product factory" do
      response = build_product_response
      factory = Bls::Core::ProductFactory.new(response)
      allow(Bls::Core::ProductFactory).to receive(:new).and_return(factory)
      allow(factory).to receive(:create)

      Bls::Core::Product.build_from_response(response)

      expect(factory).to have_received(:create).once
    end
  end
end
