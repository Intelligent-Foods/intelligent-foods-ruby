# frozen_string_literal: true

module Bls
  module Core
    class ProductFactory
      attr_accessor :response

      def initialize(response)
        @response = response
      end

      def create
        product = Product.build(response)
        product.ingredients = ingredients
        product.allergens = allergens
        product.dietary_tags = dietary_tags
        product.nutrition_facts = nutrition_facts
        product
      end

      protected

      def ingredients
        Ingredient.build_from_array(response[:ingredients])
      end

      def allergens
        Allergen.build_from_array(response[:allergens])
      end

      def dietary_tags
        DietaryTag.build_from_array(response[:dietary_tags])
      end

      def nutrition_facts
        as_packaged = NutritionFact.
                      build_from_array(response[:nutrition_facts][:as_packaged])
        as_cooked = NutritionFact.
                    build_from_array(response[:nutrition_facts].
                                     fetch(:as_cooked, []))
        { as_packaged: as_packaged, as_cooked: as_cooked }
      end
    end
  end
end
