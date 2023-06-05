# frozen_string_literal: true

module IntelligentFoods
  class OrderItemSerializer < SimpleDelegator
    def to_json
      {
        id: id,
        protein_id: protein_id,
        quantity: 1,
      }
    end
  end
end