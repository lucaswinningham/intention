# frozen_string_literal: true

module Intention
  module Null
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        payload.fetch(:intention).attributes.each do |name, attribute|
          next unless attribute.given_in?(input)
          next unless attribute.null?
          next unless attribute.value_in(input).nil?

          instance.__send__("#{name}=", attribute.null_data.call(instance))
        end

        @app.call(payload)
      end
    end
  end
end
