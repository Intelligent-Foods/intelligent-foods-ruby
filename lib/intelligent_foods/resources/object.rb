# frozen_string_literal: true

module IntelligentFoods
  class Object < OpenStruct
    def self.build(data)
      JSON.parse(data.to_json, object_class: self)
    end

    protected

    def build_post_request(uri:, body:)
      client.build_post_request(uri: uri, body: body)
    end

    def build_get_request(uri:)
      client.build_get_request(uri: uri)
    end

    def build_delete_request(uri:)
      client.build_delete_request(uri: uri)
    end

    def raise_error(error_class, response)
      error_message = build_error_message(response)
      raise error_class.new(error_message)
    end

    def client
      @client ||= IntelligentFoods.client
    end

    def build_error_message(response)
      response_body = response.data
      status_code = response_body[:status]
      error_title = response_body[:title]
      error_detail = response_body[:detail]
      "#{status_code} #{error_title} - #{error_detail}"
    end
  end
end
