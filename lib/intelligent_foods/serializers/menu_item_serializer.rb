# frozen_string_literal: true

module IntelligentFoods
  class MenuItemSerializer < SimpleDelegator
    def to_json
      {
        id: id,
        sku: sku,
        name: name,
      }
    end
  end
end
