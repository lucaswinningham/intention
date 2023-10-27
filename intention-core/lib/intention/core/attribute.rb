# frozen_string_literal: true

require_relative 'attribute/instance'
require_relative 'attribute/proxy'
require_relative 'attribute/registry'

module Intention
  module Attribute # rubocop:disable Style/Documentation
    class << self
      def new(*args, **kwargs, &block)
        Instance.new(*args, **kwargs, &block)
      end

      def proxy(*args, **kwargs, &block)
        Proxy.new(*args, **kwargs, &block)
      end

      def registry
        Registry
      end
    end
  end
end
