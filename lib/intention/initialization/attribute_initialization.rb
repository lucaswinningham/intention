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
        @value ||= if input_hash.key? attribute.hash_accessor
                     parse_given_value input_hash.fetch(attribute.hash_accessor)
                   else
                     determine_missing_value
                   end
      end

      def parse_given_value(given_value)
        if given_value.nil? && attribute.nullable?
          attribute.null_callable.call(instance)
        else
          given_value
        end
      end

      def determine_missing_value
        if attribute.required? && attribute.required_callable.call(instance)
          raise attribute.required_error
        end

        attribute.default_callable.call(instance) if attribute.default?
      end
    end
  end
end
