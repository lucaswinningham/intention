module Intention
  module Ingestion
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        process_default_attributes(payload)

        @app.call(payload)
      end

      private

      def process_default_attributes(payload)
        instance = payload.fetch(:instance)

        target_attributes(payload).each do |attribute|
          instance.__send__(attribute.accessor.setter.name, attribute.default_data.call(instance))
        end
      end

      def target_attributes(payload)
        input = payload.fetch(:input)

        payload.fetch(:intention).attributes.filter do |attribute|
          attribute.writable? && !attribute.given_in?(input) && attribute.default_data.set?
        end
      end
    end
  end
end
