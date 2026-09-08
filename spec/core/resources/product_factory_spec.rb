# frozen_string_literal: true

RSpec.describe Bls::Core::ProductFactory do
  describe "#create" do
    it "assigns the ingredients to the Product" do
      response = build_product_response
      ingredient = Bls::Core::Ingredient.build(response[:ingredients])
      factory = Bls::Core::ProductFactory.new(response)

      result = factory.create

      expect(result.ingredients).to match_array(ingredient)
    end

    it "assigns the allergens to the Product" do
      response = build_product_response
      allergen = Bls::Core::Allergen.build_from_array(response[:allergens])
      factory = Bls::Core::ProductFactory.new(response)

      result = factory.create

      expect(result.allergens).to match_array(allergen)
    end

    it "assigns the dietary tags to the Product" do
      response = build_product_response
      dietary_tags = Bls::Core::Allergen.
                     build_from_array(response[:dietary_tags])
      factory = Bls::Core::ProductFactory.new(response)

      result = factory.create

      expect(result.dietary_tags).to match_array(dietary_tags)
    end

    it "assigns the nutrition facts to the Product" do
      response = build_product_response
      factory = Bls::Core::ProductFactory.new(response)
      product = factory.create

      result = product.nutrition_facts

      expect(result.keys).to match_array([:as_packaged, :as_cooked])
    end
  end
end
