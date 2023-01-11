# frozen_string_literal: true

require_relative 'attribution/attribute'

module Intention
  module Dirty # rubocop:disable Style/Documentation
    class << self
      private

      def included(base)
        base.extend ClassMethods
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      def dirty_enabled?
        !!@dirty
      end

      private

      def dirty
        define_method :dirty? do
          @intention_cache.any? { |name, value| __send__(name) != value }
        end

        @dirty = true
      end
    end
  end
end
