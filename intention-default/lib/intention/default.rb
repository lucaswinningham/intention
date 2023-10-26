# frozen_string_literal: true

require 'intention/core'

require_relative 'default/attribute'
require_relative 'default/attribute_initialization'
require_relative 'default/initialization'

require_relative 'default/data'

module Intention
  module Default
    class << self
      def configure
        Intention.configure do |configuration|
          configuration.attribute_initialization.use(AttributeInitialization)
          configuration.initialization.use(Initialization)
          configuration.attribute.include(Attribute)

          configuration.attribute.register(:default) do |*args, **kwargs, &block|
            tap do
              default_data.set(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
