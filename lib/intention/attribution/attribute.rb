# frozen_string_literal: true

require 'securerandom'

require_relative 'accessors'

require_relative 'attribute/registry'

module Intention
  module Attribution
    class Attribute # rubocop:disable Style/Documentation
      class Error < StandardError; end
      class ClassRequiredError < Error; end
      class NameRequiredError < Error; end
      class UnparsableNameError < Error; end
      class RequiredAttributeError < Error; end

      class << self
        def registry
          @registry ||= Registry.new registry_key
        end

        private

        def registry_key
          @registry_key ||= SecureRandom.uuid
        end
      end

      attr_reader :name

      def initialize(options = {})
        @klass = options.fetch(:class) { raise ClassRequiredError }
        @name = sanitize_name options.fetch(:name) { raise NameRequiredError }

        @is_readable = options.fetch(:readable, true)
        @is_writable = options.fetch(:writable, true)
        @loads_proc = options.fetch(:loads, proc(&:itself))
        @dumps_proc = options.fetch(:dumps, proc(&:itself))

        reflux
      end

      registry.add :required, authorization_key: registry_key do
        def required(required_error_class = RequiredAttributeError)
          tap do
            @required_error = required_error_class
          end
        end

        attr_reader :required_error

        def required?
          defined? @required_error
        end
      end

      # def required(required_error_class = RequiredAttributeError)
      #   tap do
      #     @required_error = required_error_class
      #   end
      # end

      # registry.add :required, authorization_key: registry_key

      # attr_reader :required_error

      # def required?
      #   defined? @required_error
      # end

      registry.add :readable, authorization_key: registry_key do
        def readable(is_readable = true) # rubocop:disable Style/OptionalBooleanParameter
          tap do
            reflux { @is_readable = !!is_readable }
          end
        end
      end

      registry.add :writable, authorization_key: registry_key do
        def writable(is_writable = true) # rubocop:disable Style/OptionalBooleanParameter
          tap do
            reflux { @is_writable = !!is_writable }
          end
        end
      end

      registry.add :loads, authorization_key: registry_key do
        def loads(&block)
          tap do
            reflux { @loads_proc = block } if block
          end
        end
      end

      registry.add :dumps, authorization_key: registry_key do
        def dumps(&block)
          tap do
            reflux { @dumps_proc = block } if block
          end
        end
      end

      registry.add :default, authorization_key: registry_key do
        def default(default_value = nil)
          tap do
            @default_value = default_value
          end
        end

        attr_reader :default_value

        def default?
          defined? @default_value
        end
      end

      # def renamed(new_name)
      #   tap do
      #     undefine_accessors
      #     @name = sanitize_name new_name
      #     define_accessors
      #   end
      # end

      private

      def sanitize_name(name)
        name.to_sym
      rescue NoMethodError
        raise UnparsableNameError, name.inspect
      end

      def reflux(&block)
        Accessors.undefine(class: @klass, name: name)

        block&.call

        Accessors.define(
          class: @klass,
          name: name,
          readable: @is_readable,
          writable: @is_writable,
          loads: @loads_proc,
          dumps: @dumps_proc
        )
      end
    end
  end
end
