# frozen_string_literal: true

module Intention
  module Default
    class Data
      def set?
        @set
      end

      def set(&block)
        @callable = block || proc {}

        @set = true
      end

      def call(*args, **kwargs, &block)
        @callable.call(*args, **kwargs, &block)
      end
    end
  end
end
