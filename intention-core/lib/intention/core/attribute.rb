require_relative 'attribute/instance'
require_relative 'attribute/proxy'
require_relative 'attribute/registry'

module Intention
  module Attribute
    class << self
      def new(...)
        Instance.new(...)
      end

      def proxy(...)
        Proxy.new(...)
      end

      def registry
        Registry
      end
    end
  end
end
