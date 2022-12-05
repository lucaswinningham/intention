# frozen_string_literal: true

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
        instance_variable_set(:@intention_input_hash, input_hash)

        initialize_intention
      end

      private

      attr_reader :intention_input_hash

      def initialize_intention(input_hash = nil)
        input_hash ||= instance_variable_get :@intention_input_hash

        symbolized_input_hash = input_hash.transform_keys(&:to_sym)

        attributes.each_value do |attribute|
          AttributeInitialization.new(
            instance: self,
            attribute: attribute,
            input_hash: symbolized_input_hash
          ).call
        end
      end
    end
  end
end
