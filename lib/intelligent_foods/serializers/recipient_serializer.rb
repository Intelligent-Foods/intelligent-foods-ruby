# frozen_string_literal: true

module IntelligentFoods
  class RecipientSerializer < SimpleDelegator
    def to_json
      recipient_object = {
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
      remove_blank_values(recipient_object)
    end

    protected

    def remove_blank_values(obj)
      obj.delete_if do |_k, v|
        v.blank?
      end
    end
  end
end
