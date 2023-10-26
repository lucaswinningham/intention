# frozen_string_literal: true

module Intention
  module Required
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        payload.fetch(:intention).attributes.each do |name, attribute|
          next if attribute.given_in?(input)
          next unless attribute.required?
          next unless attribute.required_data.call(instance)

          raise attribute.required_data.error_klass
        end

        @app.call(payload)
      end
    end
  end
end
