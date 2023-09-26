# frozen_string_literal: true

require_relative 'attribution'

module Intention
  module Serialization # rubocop:disable Style/Documentation
    class << self
      private

      def included(base)
        base.include Attribution

        base.extend ClassMethods
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      private

      def serializable
        define_method :to_h do
          attributes.each_with_object({}) do |(attribute_name, attribute), hash|
            # should `renamed` take a :from and :to key for this?
            next if attribute.withheld?

            value = __send__(attribute_name)

            hash[attribute_name] = attribute.dumps_callable.call(value, self)
          end
        end
      end
    end
  end
end
