# frozen_string_literal: true

require_relative 'middleware/chain'

module Intention
  module Middleware
    class << self
      def included(base)
        base.include InstanceMethods
        base.extend ClassMethods
      end
    end

    module InstanceMethods
      def initialize(succ)
        @succ = succ
      end

      def call(payload)
        run(payload, &succ)
      end

      private

      attr_reader :succ
    end

    module ClassMethods
      def run(&block)
        define_method(:run, &block)
      end
    end
  end
end
