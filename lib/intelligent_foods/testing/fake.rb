# frozen_string_literal: true

module IntelligentFoods
  module Testing
    class Fake
      def self.configure(*); end

      class MenuItem
        def self.create(id: SecureRandom.uuid, sku: "SKU1",
                        name: "FakeMenuItem")
          OpenStruct.new(id: id, sku: sku, name: name)
        end
      end

      class Menu
        def self.new(id: Date.today.to_s)
          items = [Fake::MenuItem.create]
          OpenStruct.new(id: id, deadline: Time.zone.now,
                         shipping_fee: 9.99, items: items)
        end

        def self.find(id)
          items = [Fake::MenuItem.create]
          OpenStruct.new(id: id, deadline: Time.zone.now,
                         shipping_fee: 9.99, items: items)
        end
      end

      class MenuItemSerializer
        def initialize(menu_item)
          OpenStruct.new(id: menu_item.id, sku: menu_item.sku,
                         name: menu_item.name)
        end
      end

      class Recipient
        def self.new(name: nil, street1: nil, street2: nil, city: nil,
                     state: nil, zip: nil, zip4: nil, email: nil, phone: nil,
                     delivery_instructions: nil)
          OpenStruct.new(name: name, street1: street1, street2: street2,
                         city: city, state: state, zip: zip, zip4: zip4,
                         email: email, phone: phone,
                         delivery_instructions: delivery_instructions)
        end
      end

      class Order
        def initialize(*)
          self
        end

        def id
          @id ||= SecureRandom.uuid
        end

        def create!
          items = [Fake::MenuItem.create]
          ship_to = Fake::Recipient.new
          OpenStruct.new(id: SecureRandom.uuid, items: items,
                         ship_to: ship_to)
        end

        def cancel!
          OpenStruct.new(id: SecureRandom.uuid,
                         status: "CANCELLED")
        end
      end

      class OrderItem
        def self.new(sku:, quantity:, protein_sku:)
          OpenStruct.new(sku: sku, quantity: quantity, protein_sku: protein_sku)
        end
      end

      def self.client
        Fake::Client.new
      end

      class ApiClient
        def self.new(*)
          Fake::Client.new
        end
      end

      class ApiClientSerializer
        def self.serialize(*)
          OpenStruct.new(id: nil, secret: nil).to_h
        end
      end

      class Client
        def initialize(*)
          self
        end

        def authenticated?
          false
        end

        def authenticate!; end
      end

      class OrderNotCreatedError < StandardError; end

      class OrderNotCancelledError < StandardError; end

      class AuthenticationError < StandardError; end
    end
  end
end
