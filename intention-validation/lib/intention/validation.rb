require 'intention/core'

require_relative 'validation/attribute'
require_relative 'validation/initialization'

module Intention
  module Validation
    class << self
      def configure
        @configured ||= begin
          Intention.configure do |configuration|
            configuration.initialization.use(Initialization)
            configuration.attribute.include(Attribute)
            # # TODO: uncomment when we've figured out attributes scopes
            # configuration.attributes.scope(:required) { |attribute| attribute.required_data.set? }
          end

          configure_attribute_registrations

          :validation_configured
        end
      end

      private

      def configure_attribute_registrations
        configure_required
      end

      def configure_required
        Intention.configure do |configuration|
          configuration.attribute.register(:required!) do |*args, **kwags, &block|
            tap do
              required_data.set(*args, **kwags, &block)
            end
          end
        end
      end
    end
  end
end
