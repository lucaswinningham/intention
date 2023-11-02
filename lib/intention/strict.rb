require_relative 'attribution/attribute'

module Intention
  class UnexpectedKeysError < Error; end

  module Strict
    class << self
      private

      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods
      def strict?
        !!@strict
      end

      private

      def strict!(is_strict = true) # rubocop:disable Style/OptionalBooleanParameter
        @strict = is_strict
      end
    end
  end
end
