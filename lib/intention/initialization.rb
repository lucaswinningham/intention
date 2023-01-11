# frozen_string_literal: true

require_relative 'initialization/verify_input_hash'
require_relative 'initialization/attribute_initialization'

module Intention
  module Initialization # rubocop:disable Style/Documentation
    class << self
      private

      def included(base)
        base.include InstanceMethods
      end
    end

    module InstanceMethods # rubocop:disable Style/Documentation
      def initialize(input_hash = {})
        VerifyInputHash.call(input_hash: input_hash, attributes: attributes) if self.class.strict?

        @intention_input_hash = input_hash

        initialize_intention @intention_input_hash
      end

      private

      attr_reader :intention_input_hash

      def initialize_intention(input_hash = {})
        symbolized_input_hash = input_hash.transform_keys(&:to_sym)

        cache = attributes.each_value.with_object({}) do |attribute, hash|
          next unless attribute.accessible?

          hash[attribute.name] = AttributeInitialization.new(
            instance: self,
            attribute: attribute,
            input_hash: symbolized_input_hash
          ).call
        end

        @intention_cache = cache if self.class.dirty_enabled?
      end
    end
  end
end
