# frozen_string_literal: true

require_relative 'initialization/attribute_initialization'

module Intention
  module Initialization # rubocop:disable Style/Documentation
    class << self
      def included(base)
        base.include InstanceMethods
      end
    end

    module InstanceMethods
      def initialize(input_hash = {})
        instance_variable_set(:@intention_input_hash, input_hash)

        initialize_intention
      end

      attr_reader :intention_input_hash

      def initialize_intention(input_hash = nil)
        input_hash ||= instance_variable_get(:@intention_input_hash)
        attributes_hash = __send__ :intention_attributes_hash
    
        attributes_hash.values.each do |attribute|
          AttributeInitialization.new(
            instance: self,
            attribute: attribute,
            input_hash: input_hash
          ).call
        end
      end
    end
  end
end
