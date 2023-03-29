# frozen_string_literal: true

module IntelligentFoods
  class Menu
    attr_accessor :id

    def initialize(id: nil)
      @id = id
    end

    def self.all
      uri = URI("#{IntelligentFoods.base_url}/menus")
      request = Net::HTTP::Get.new(uri)
      client = IntelligentFoods.client
      response = client.execute_request(request: request, uri: uri)
      if response.success?
        response.data.map { |id| IntelligentFoods::Menu.new(id: id) }
      else
        []
      end
    end
  end
end
