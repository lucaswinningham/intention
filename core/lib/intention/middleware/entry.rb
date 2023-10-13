# frozen_string_literal: true

module Intention
  module Middleware
    class Entry
      attr_reader :klass, :args, :kwargs, :block

      def initialize(klass, *args, **kwargs, &block)
        @klass = klass
        @args = args
        @kwargs = kwargs
        @block = block
      end
    end
  end
end
