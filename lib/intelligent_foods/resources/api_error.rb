# frozen_string_literal: true

module IntelligentFoods
  class ApiError < StandardError
    attr_reader :status, :title, :details

    def initialize(status:, title:, details: nil)
      @status = status
      @title = title
      @details = details
      super
    end

    def message
      if details.blank?
        "#{status} - #{title}"
      else
        "#{status} #{title} - #{description}"
      end
    end

    def self.build(response)
      data = response.data
      data => { status:, title:, details: }
      new(status: status, title: title, details: details)
    end

    protected

    def description
      details[:description]
    end
  end
end
