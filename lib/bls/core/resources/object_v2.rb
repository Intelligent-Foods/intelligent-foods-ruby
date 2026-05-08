# frozen_string_literal: true

module Bls
  module Core
    class ObjectV2 < Bls::Core::Object
      def self.build_from_array(array)
        array.map { |object| build(object) }
      end

      def resources_path
        "#{api.base_url}/api/#{object_name.downcase}"
      end

      def resource_path
        "#{api.base_url}/api/#{object_name.downcase}/#{id}"
      end

      def api
        @api ||= Bls::Core::V2.build
      end
    end
  end
end
