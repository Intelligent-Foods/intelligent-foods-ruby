# frozen_string_literal: true

module IntelligentFoods
  class Order < IntelligentFoods::Object
    attr_reader :status

    ACCEPTED = "accepted"
    CANCELLED = "cancelled"
    ERROR = "error"
    IN_PROCESS = "in_process"
    INITIALIZED = "initialized"
    PROCESSED = "processed"

    def initialize(args = {})
      @status = INITIALIZED
      super
    end

    def cancel!
      uri = URI("#{IntelligentFoods.base_url}/order/#{id}")
      request = Net::HTTP::Delete.new(uri)
      client = IntelligentFoods.client
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        mark_as_cancelled
        self
      else
        mark_as_invalid
        raise OrderNotCancelledError
      end
    end

    def cancelled?
      status.downcase == CANCELLED
    end

    def valid?
      status.downcase != ERROR
    end

    protected

    def mark_as_cancelled
      @status = CANCELLED
    end

    def mark_as_invalid
      @status = ERROR
    end
  end
end
