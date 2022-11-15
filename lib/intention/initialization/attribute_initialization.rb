# frozen_string_literal: true

module Intention
  module Initialization
    class AttributeInitialization # rubocop:disable Style/Documentation
      attr_reader :instance, :attribute, :input_hash

      def initialize(options = {})
        @instance = options.fetch(:instance)
        @attribute = options.fetch(:attribute)
        @input_hash = options.fetch(:input_hash)
      end

      def call
        instance.__send__("#{attribute.name}=", value)
      end

      private

      def value
        @value ||= input_hash.fetch(attribute.name) do
          raise attribute.required_error if attribute.required?

          attribute.default_value if attribute.default?
        end
      end
    end
  end
end
