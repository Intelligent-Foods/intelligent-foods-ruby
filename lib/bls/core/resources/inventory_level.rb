# frozen_string_literal: true

module Bls
  module Core
    class InventoryLevel < Core::Object
      def object_name
        "inventory-level"
      end

      def resources_path
        "#{api.base_url}/products/inventory-levels"
      end

      def to_json
        {
          sku: sku,
          date: date,
          distribution_center: distribution_center,
          quantity: quantity
        }
      end

      def self.retrieve_all
        resource = new
        api_client = resource.client
        response = api_client.get(path: resource.resources_path)
        if response.success?
          response.data[:inventory].map { |inventory| build(inventory) }
        else
          raise ResourceRetrievalError.build(response)
        end
      end
    end
  end
end
