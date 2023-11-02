require 'intention/core'

require_relative 'required/attribute'
require_relative 'required/initialization'

module Intention
  module Required
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

          :required_configured
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
