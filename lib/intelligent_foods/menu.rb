# frozen_string_literal: true

module IntelligentFoods
  class Menu
    attr_accessor :id

    def initialize(id: nil)
      @id = id
    end

    def self.all
      instance = new
      instance.all
    end

    def all
      menu_ids = get_menu_ids
      menu_ids.map { |id| IntelligentFoods::Menu.new(id: id) }
    end

    protected

    def get_menu_ids
      assign_request_headers
      perform_request
    end

    def request
      @request ||= Net::HTTP::Get.new(uri)
    end

    def uri
      @uri ||= URI("#{IntelligentFoods.base_url}/menus")
    end

    def assign_request_headers
      client = IntelligentFoods.client
      request["Authorization"] = "Bearer #{client.access_token}"
    end

    def perform_request
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        response = http.request(request)
        if response.code.to_i == 200
          JSON.parse(response.body, symbolize_names: true)
        else
          []
        end
      end
    end
  end
end
