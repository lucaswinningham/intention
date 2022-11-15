# frozen_string_literal: true

module Intention
  module Attribution
    class Attribute
      class Registry # rubocop:disable Style/Documentation
        class Error < StandardError; end
        class UnauthorizedError < Error; end

        def initialize(authorization_key)
          @authorization_key = authorization_key
        end

        def add(entry, authorization_key:, &block)
          raise UnauthorizedError unless authorization_key == @authorization_key

          entries.push(entry).tap { block&.call }
        end

        def each(&block)
          entries.dup.each(&block)
        end

        private

        def entries
          @entries ||= []
        end
      end
    end
  end
end
