require_relative 'attribute'

module Intention
  module Access
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        assign_attribute_values(payload)

        @app.call(payload)
      end

      def assign_attribute_values(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        target_attributes(payload).each do |attribute|
          # TODO: test!
          if attribute.writable?
            instance.__send__(attribute.accessor.setter.name, attribute.value_in(input))
          elsif attribute.readable?
            instance_variable_name = attribute.accessor.instance_variable_name

            instance.instance_variable_set(instance_variable_name, attribute.value_in(input))
          end
        end
      end

      def target_attributes(payload)
        input = payload.fetch(:input)

        payload.fetch(:intention).attributes.filter { |attribute| attribute.given_in?(input) }
      end
    end
  end
end
