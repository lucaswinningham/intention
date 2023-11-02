module Intention
  module Ingestion
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        process_default_attributes(payload)
        process_null_attributes(payload)

        @app.call(payload)
      end

      private

      def process_default_attributes(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        # # TODO: uncomment when we've figured out attributes scopes
        # payload.fetch(:intention).attributes.default.writable.each do |name, attribute|
        #   next if attribute.given_in?(input)

        #   instance.__send__(attribute.setter.name, attribute.default_data.call(instance))
        # end

        payload.fetch(:intention).attributes.each do |_, attribute|
          next unless attribute.default_data.set?
          next unless attribute.klass.any_method_defined?(attribute.setter.name)
          next if attribute.given_in?(input)

          instance.__send__(attribute.setter.name, attribute.default_data.call(instance))
        end
      end

      def process_null_attributes(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        # # TODO: uncomment when we've figured out attributes scopes
        # payload.fetch(:intention).attributes.null.writable.each do |name, attribute|
        #   next unless attribute.given_in?(input) && attribute.value_in(input).nil?

        #   instance.__send__(attribute.setter.name, attribute.null_data.call(instance))
        # end

        payload.fetch(:intention).attributes.each do |_, attribute|
          next unless attribute.null_data.set?
          next unless attribute.klass.any_method_defined?(attribute.setter.name)
          next unless attribute.given_in?(input) && attribute.value_in(input).nil?

          instance.__send__(attribute.setter.name, attribute.null_data.call(instance))
        end
      end
    end
  end
end
