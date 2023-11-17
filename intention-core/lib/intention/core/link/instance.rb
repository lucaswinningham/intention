require 'delegate'

require_relative 'attributes'

module Intention
  module Link
    class Instance
      def initialize(options = {})
        @klass = options.fetch(:klass)
      end

      def attribute_initialization
        @attribute_initialization ||= InjectableMiddleware.new(
          Intention.configuration.attribute_initialization,
          intention: self,
        )
      end

      def initialization
        @initialization ||= InjectableMiddleware.new(
          Intention.configuration.initialization,
          intention: self,
        )
      end

      def attributes
        @attributes ||= Attributes.new(intention: self, klass: @klass)
      end

      class InjectableMiddleware < SimpleDelegator
        def initialize(initial_middleware, injections = {})
          super(
            Support::Middleware::Builder.new do
              use(initial_middleware)
            end
          )

          @injections = injections
        end

        def call(payload = {})
          super(payload.merge(@injections))
        end
      end
    end
  end
end
