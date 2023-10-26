# frozen_string_literal: true

module Intention
  module Default
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)
        values = payload.fetch(:values)

        payload.fetch(:intention).attributes.each do |name, attribute|
          next if attribute.given_in?(input)
          next unless attribute.default?

          instance.__send__("#{name}=", attribute.default_data.call(instance))

          # values[attribute.name] = attribute.default_data.call(instance)
        end

        @app.call(payload)
      end
    end
  end
end
