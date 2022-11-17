# frozen_string_literal: true

module Intention
  module Attribution
    class Attribute
      class AuthorizedAccessRegistry # rubocop:disable Style/Documentation
        class UnauthorizedError < Error; end

        def initialize(key)
          @key = key
        end

        def add(name, key:)
          raise UnauthorizedError unless key == @key

          entries.push(name)
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
