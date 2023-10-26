# frozen_string_literal: true

require_relative 'attribute/instance'
require_relative 'attribute/registry'

module Intention
  module Attribute # rubocop:disable Style/Documentation
    class << self
      def registry
        Registry
      end
    end
  end
end
