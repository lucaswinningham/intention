# frozen_string_literal: true

require 'intention/core'

require_relative 'required/attribute'
require_relative 'required/attribute_initialization'
require_relative 'required/initialization'

require_relative 'required/data'

module Intention
  module Required
    class << self
      def configure
        Intention.configure do |configuration|
          configuration.attribute_initialization.use(AttributeInitialization)
          configuration.initialization.use(Initialization)
          configuration.attribute.include(Attribute)
          configuration.attribute.register(:required!) do |*args, **kwargs, &block|
            tap do
              required_data.set(*args, **kwargs, &block)
            end
          end
        end
      end
    end
  end
end
