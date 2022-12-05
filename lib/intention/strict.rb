# frozen_string_literal: true

require_relative 'attribution/attribute'

module Intention
  class UnexpectedKeysError < Error; end

  module Strict # rubocop:disable Style/Documentation
    class << self
      private

      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
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
