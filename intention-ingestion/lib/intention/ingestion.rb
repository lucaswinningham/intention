require 'intention/core'
require 'intention/access'

require_relative 'ingestion/loads'
require_relative 'ingestion/null'

require_relative 'ingestion/attribute'
require_relative 'ingestion/initialization'

module Intention
  module Ingestion
    class << self
      def configure
        @configured ||= begin
          Intention::Access.configure

          Intention.configure do |configuration|
            configuration.initialization.use(Initialization)
            configuration.attribute.include(Attribute)
          end

          configure_attribute_registrations

          :ingestion_configured
        end
      end

      private

      def configure_attribute_registrations
        configure_loads
        configure_default
        configure_null
        configure_coerce
      end

      def configure_loads
        Intention.configure do |configuration|
          configuration.attribute.register(:loads) do |&block|
            tap do
              accessor.setter.middleware.use(Loads::Setter, &block) unless block.nil?
            end
          end
        end
      end

      def configure_default
        Intention.configure do |configuration|
          configuration.attribute.register(:default) do |&block|
            tap do
              default_data.set(&block) unless block.nil?
            end
          end
        end
      end

      def configure_null
        Intention.configure do |configuration|
          configuration.attribute.register(:null) do |&block|
            tap do
              accessor.setter.middleware.use(Null::Setter, &block) unless block.nil?
            end
          end
        end
      end

      def configure_coerce
        Intention.configure do |configuration|
          configuration.attribute.register(:coerce) do |&block|
            default(&block).null(&block)
          end
        end
      end
    end
  end
end
