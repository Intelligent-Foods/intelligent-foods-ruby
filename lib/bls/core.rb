# frozen_string_literal: true

require "base64"
require "json"
require "net/http"
require "ostruct"

require_relative "core/api_client"
require_relative "core/api/v1"
require_relative "core/api/v2"
require_relative "core/api/v1/authenticator"
require_relative "core/api/v2/authenticator"
require_relative "core/api_operations/retrieve"
require_relative "core/authorization/base"
require_relative "core/authorization/basic"
require_relative "core/authorization/blank"
require_relative "core/resources/api_error"
require_relative "core/authorization/bearer"
require_relative "core/resources/object"
require_relative "core/resources/object_v2"
require_relative "core/resources/allergen"
require_relative "core/resources/dietary_tag"
require_relative "core/resources/ingredient"
require_relative "core/resources/inventory_level"
require_relative "core/resources/nutrition_fact"
require_relative "core/resources/order"
require_relative "core/resources/order_item"
require_relative "core/serializers/order_item_serializer"
require_relative "core/resources/menu"
require_relative "core/resources/menu_item"
require_relative "core/serializers/menu_item_serializer"
require_relative "core/resources/product"
require_relative "core/resources/product_factory"
require_relative "core/resources/recipient"
require_relative "core/serializers/recipient_serializer"
require_relative "core/version"
require_relative "core/errors"

module Bls
  module Core
    class Error < StandardError; end

    class << self
      attr_accessor :client_id, :client_secret, :environment, :username,
                    :password

      def configure
        yield self
      end
    end
  end
end
