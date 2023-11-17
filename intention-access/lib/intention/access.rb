require 'intention/core'
require 'intention/support'

require_relative 'access/attribute'
require_relative 'access/attribute_initialization'
require_relative 'access/initialization'

module Intention
  module Access
    class << self
      def configure
        @configured ||= begin
          Intention.configure do |configuration|
            configuration.attribute_initialization.use(AttributeInitialization)
            configuration.initialization.use(Initialization)
            configuration.attribute.include(Attribute)
          end

          configure_attribute_registrations

          :access_configured
        end
      end

      private

      def configure_attribute_registrations
        configure_accessible
        configure_inaccessible
        configure_readonly
        configure_writeonly

        configure_ignore_reader
        configure_ignore_writer
        configure_ignore_accessor
      end

      def configure_accessible
        Intention.configure do |configuration|
          configuration.attribute.register(:accessible) do
            tap do
              klass.publicize_method(accessor.getter.name)
              klass.publicize_method(accessor.setter.name)
            end
          end
        end
      end

      def configure_inaccessible
        Intention.configure do |configuration|
          configuration.attribute.register(:inaccessible) do
            tap do
              klass.privatize_method(accessor.getter.name)
              klass.privatize_method(accessor.setter.name)
            end
          end
        end
      end

      def configure_readonly
        Intention.configure do |configuration|
          configuration.attribute.register(:readonly) do
            tap do
              klass.publicize_method(accessor.getter.name)
              klass.privatize_method(accessor.setter.name)
            end
          end
        end
      end

      def configure_writeonly
        Intention.configure do |configuration|
          configuration.attribute.register(:writeonly) do
            tap do
              klass.privatize_method(accessor.getter.name)
              klass.publicize_method(accessor.setter.name)
            end
          end
        end
      end

      def configure_ignore_accessor
        Intention.configure do |configuration|
          configuration.attribute.register(:ignore_accessor) do
            tap do
              ignore_reader.ignore_writer
            end
          end
        end
      end

      def configure_ignore_reader
        Intention.configure do |configuration|
          configuration.attribute.register(:ignore_reader) do
            tap do
              klass.undefine_method(accessor.getter.name)
            end
          end
        end
      end

      def configure_ignore_writer
        Intention.configure do |configuration|
          configuration.attribute.register(:ignore_writer) do
            tap do
              klass.undefine_method(accessor.setter.name)
            end
          end
        end
      end
    end
  end
end
