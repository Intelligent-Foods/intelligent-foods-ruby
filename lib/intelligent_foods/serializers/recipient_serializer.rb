# frozen_string_literal: true

module IntelligentFoods
  class RecipientSerializer < SimpleDelegator
    def to_json
      {
        name: name,
        street1: street1,
        street2: street2,
        city: city,
        state: state,
        zip: zip,
        zip4: zip4,
        email: email,
        phone: phone,
        delivery_instructions: delivery_instructions,
      }
    end
  end
end
