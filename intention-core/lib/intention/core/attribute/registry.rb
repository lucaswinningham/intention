require 'set'

module Intention
  module Attribute
    module Registry
      class << self
        def add(name)
          registry.add(name)
        end

        def each(&block)
          registry.each(&block)
        end

        def to_s
          "{#{registry.join(',')}}"
        end

        private

        def registry
          @registry ||= Set.new
        end
      end
    end
  end
end
