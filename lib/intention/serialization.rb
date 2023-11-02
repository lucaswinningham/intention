require_relative 'attribution'

module Intention
  module Serialization
    class << self
      private

      def included(base)
        base.include Attribution

        base.extend ClassMethods
      end
    end

    module ClassMethods
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
