# frozen_string_literal: true

module IntelligentFoods
  class Menu < IntelligentFoods::Object
    def initialize(args = {})
      super
    end

    def self.build_from_response(data)
      menu = build(data)
      menu.items = MenuItem.build(data[:items])
      menu
    end

    def self.all
      uri = URI("#{IntelligentFoods.base_url}/menus")
      request = Net::HTTP::Get.new(uri)
      client = IntelligentFoods.client
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        response.data.map { |id| Menu.new(id: id) }
      else
        []
      end
    end

    def self.find(menu_id)
      uri = URI("#{IntelligentFoods.base_url}/menu/#{menu_id}")
      request = Net::HTTP::Get.new(uri)
      client = IntelligentFoods.client
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        Menu.build_from_response(response.data)
      else
        raise MenuNotFoundError
      end
    end
  end
end
