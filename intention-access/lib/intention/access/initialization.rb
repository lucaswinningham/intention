module Intention
  module Access
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        input = payload.fetch(:input)
        instance = payload.fetch(:instance)

        payload.fetch(:intention).attributes.each do |_, attribute|
          next unless attribute.klass.any_method_defined?(attribute.setter.name)

          instance.__send__(attribute.setter.name, attribute.value_in(input, nil))
        end

        @app.call(payload)
      end
    end
  end
end
