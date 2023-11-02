module Intention
  class RequiredAttributeError < StandardError; end

  module Required
    class Data
      attr_reader :error_klass

      def set?
        @set
      end

      def set(error_klass = RequiredAttributeError, &block)
        @error_klass = error_klass
        @callable = block || proc { true }

        @set = true
      end

      def call(...)
        @callable.call(...)
      end
    end
  end
end
