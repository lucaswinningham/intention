require 'delegate'
require 'middleware'

require_relative 'attributes'

module Intention
  module Link
    class Instance
      def initialize(options = {})
        @klass = options.fetch(:klass)
      end

      def attribute_initialization
        @attribute_initialization ||= begin
          initial_middleware = Intention.configuration.attribute_initialization

          InjectableMiddleware.new(initial_middleware).tap do |tapped|
            tapped.injections.merge!(intention: self)
          end
        end
      end

      def initialization
        @initialization ||= begin
          initial_middleware = Intention.configuration.initialization

          InjectableMiddleware.new(initial_middleware).tap do |tapped|
            tapped.injections.merge!(intention: self)
          end
        end
      end

      def attributes
        @attributes ||= Attributes.new(intention: self, klass: @klass)
      end

      class InjectableMiddleware < SimpleDelegator
        def initialize(initial_middleware)
          super(
            Middleware::Builder.new do
              use(initial_middleware)
            end
          )
        end

        def injections
          @injections ||= {}
        end

        def call(payload = {})
          super(payload.merge(injections))
        end
      end
    end
  end
end
