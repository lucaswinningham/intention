# frozen_string_literal: true

require_relative 'attributes'

module Intention
  module Link
    class Instance # rubocop:disable Style/Documentation
      def initialize(options = {})
        @klass = options.fetch(:klass)
      end

      def attribute_initialization
        @attribute_initialization ||= Middleware::Builder.new do
          use(Intention.configuration.attribute_initialization)
        end
      end

      def initialization
        @initialization ||= Middleware::Builder.new do
          use(Intention.configuration.initialization)
        end
      end

      def attributes
        @attributes ||= Attributes.new(intention: self, klass: @klass)
      end
    end
  end
end
