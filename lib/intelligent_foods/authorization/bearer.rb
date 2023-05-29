# frozen_string_literal: true

module IntelligentFoods
  class Authorization::Bearer < Authorization
    def header
      "Bearer #{token}"
    end
  end
end
