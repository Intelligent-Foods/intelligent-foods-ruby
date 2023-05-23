# frozen_string_literal: true

module IntelligentFoods
  class Object < OpenStruct
    def self.build(data)
      JSON.parse(data.to_json, object_class: self)
    end
  end
end
