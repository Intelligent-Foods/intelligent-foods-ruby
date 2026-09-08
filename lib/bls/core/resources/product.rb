# frozen_string_literal: true

module Bls
  module Core
    class Product < Bls::Core::ObjectV2
      def object_name
        "products"
      end

      def self.build_from_response(data)
        factory = ProductFactory.new(data)
        factory.create
      end
    end
  end
end
