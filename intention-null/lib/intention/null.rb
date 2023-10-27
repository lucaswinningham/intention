# frozen_string_literal: true

require 'intention/core'

require_relative 'null/attribute'
require_relative 'null/attribute_initialization'
require_relative 'null/initialization'

require_relative 'null/data'

module Intention
  module Null
    class << self
      def configure
        @configured ||= begin
          Intention.configure do |configuration|
            configuration.attribute_initialization.use(AttributeInitialization)
            configuration.initialization.use(Initialization)
            configuration.attribute.include(Attribute)

            configuration.attribute.register(:null) do |*args, **kwargs, &block|
              tap do
                null_data.set(*args, **kwargs, &block)
              end
            end
          end

          :null_configured
        end
      end
    end
  end
end
