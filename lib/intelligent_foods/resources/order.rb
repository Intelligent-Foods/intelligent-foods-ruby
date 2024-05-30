# frozen_string_literal: true

module IntelligentFoods
  class Order < IntelligentFoods::Object
    ACCEPTED = "accepted"
    CANCELLED = "cancelled"
    ERROR = "error"
    IN_PROCESS = "in_process"
    INITIALIZED = "initialized"
    PROCESSED = "processed"

    def initialize(args = {})
      super
    end

    def self.build_from_response(data)
      order = build(data)
      order[:items] = OrderItem.build(data[:items])
      order[:ship_to] = Recipient.build(data[:ship_to])
      order
    end

    def create!
      uri = URI("#{IntelligentFoods.base_url}/order")
      request = client.build_post_request(uri: uri, body: request_body)
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        Order::build_from_response(response.data)
      else
        mark_as_invalid
        raise OrderNotCreatedError.build(response)
      end
    end

    def cancel!
      uri = URI("#{IntelligentFoods.base_url}/order/#{id}")
      request = Net::HTTP::Delete.new(uri)
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        mark_as_cancelled
        self
      else
        mark_as_invalid
        raise OrderNotCancelledError.build(response)
      end
    end

    def update!
      uri = URI("#{IntelligentFoods.base_url}/order/#{id}")
      request = client.build_patch_request(uri: uri, body: update_request_body)
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        Order::build_from_response(response.data)
      else
        mark_as_invalid
        raise OrderNotUpdatedError.build(response)
      end
    end

    def request_body
      @request_body ||= {
        menu_id: menu.id,
        reference_id: external_id,
        ship_to: ship_to,
        delivery_date: delivery_date,
        items: items_json,
      }
    end

    def update_request_body
      {
        ship_to: ship_to,
      }
    end

    def cancelled?
      status.downcase == CANCELLED
    end

    def valid?
      status.downcase != ERROR
    end

    def accepted?
      status.downcase == ACCEPTED
    end

    protected

    def mark_as_cancelled
      self[:status] = CANCELLED
    end

    def mark_as_invalid
      self[:status] = ERROR
    end

    def items_json
      return if items.nil?

      items.map do |item|
        OrderItemSerializer.new(item).to_json
      end
    end

    def ship_to
      RecipientSerializer.new(recipient).to_json
    end
  end
end
