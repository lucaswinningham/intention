# frozen_string_literal: true

module Intention
  module Initialization # rubocop:disable Style/Documentation
    class << self
      def included(base)
        base.include InstanceMethods
      end
    end

    module InstanceMethods # rubocop:disable Style/Documentation
      def initialize(input_hash = {})
        instance_variable_set(:"@#{Intention.config.instance_input_hash_name}", input_hash)

        initialize_intention
      end

      private

      attr_reader :"#{Intention.config.instance_input_hash_name}"

      def initialize_intention(input_hash = nil)
        input_hash ||= instance_variable_get(:"@#{Intention.config.instance_input_hash_name}")

        attributes.each do |name, attribute|
          value = input_hash.fetch(attribute.name) { input_hash.fetch(attribute.name.to_s, nil) }

          if value.nil?
            raise(attribute.required_error, nil.inspect) if attribute.required?

            value = attribute.default_value
          end

          send("#{name}=", value)
        end
      end
    end
  end
end
