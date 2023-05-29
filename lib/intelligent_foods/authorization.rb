# frozen_string_literal: true

module IntelligentFoods
  class Authorization
    attr_reader :token

    def initialize(token:)
      @token = token
    end
  end
end
