# frozen_string_literal: true

module IntelligentFoods
  class MenuNotFoundError < StandardError; end

  class OrderNotCancelledError < StandardError; end

  class OrderNotCreatedError < StandardError; end

  class AuthenticationError < StandardError; end
end
