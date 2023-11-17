require 'intention/core'
require 'intention/access'

require_relative 'validation/reject'

require_relative 'validation/attribute'
require_relative 'validation/initialization'

module Intention
  module Validation
    class << self
      def configure
        @configured ||= begin
          Intention::Access.configure

          Intention.configure do |configuration|
            configuration.initialization.use(Initialization)
            configuration.attribute.include(Attribute)
          end

          configure_attribute_registrations

          :validation_configured
        end
      end

      private

      def configure_attribute_registrations
        configure_required
        configure_reject
        configure_allow
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

      def configure_reject
        Intention.configure do |configuration|
          configuration.attribute.register(:reject!) do |error_klass = nil, &block|
            raise Reject::BlockRequiredError if block.nil?

            tap do
              accessor.setter.middleware.use(Reject::Setter) do |value|
                raise(error_klass || RejectedAttributeError) if block.call(value)
              end
            end
          end
        end
      end

      def configure_allow
        Intention.configure do |configuration|
          configuration.attribute.register(:allow!) do |error_klass = nil, &block|
            raise Allow::BlockRequiredError if block.nil?

            tap do
              accessor.setter.middleware.use(Allow::Setter) do |value|
                raise(error_klass || AllowedAttributeError) unless block.call(value)
              end
            end
          end
        end
      end
    end
  end
end
