# frozen_string_literal: true

require 'securerandom'

require_relative 'accessors'

require_relative 'attribute/authorized_access_registry'

module Intention
  class RequiredAttributeError < Error; end

  module Attribution
    class Attribute # rubocop:disable Style/Documentation
      class ClassRequiredError < Error; end
      class NameRequiredError < Error; end
      class UnparsableNameError < Error; end

      class << self
        def registry
          @registry ||= AuthorizedAccessRegistry.new(key)
        end

        private

        def key
          @key ||= SecureRandom.uuid
        end
      end

      attr_reader :name, :required_error, :required_callable, :default_callable, :null_callable, :rename_from

      def initialize(options = {})
        @klass = options.fetch(:class) { raise ClassRequiredError }
        @name = sanitize_name options.fetch(:name) { raise NameRequiredError }

        @is_readable = options.fetch(:readable, true)
        @is_writable = options.fetch(:writable, true)
        @loads_callable = options.fetch(:loads, proc { |value| value })
        @dumps_callable = options.fetch(:dumps, proc { |value| value })

        reflux
      end

      def required(klass = RequiredAttributeError, &block)
        tap do
          reset_default
          @required_error = klass
          @required_callable = block || proc { true }
        end
      end

      registry.add :required, key: key

      def required?
        !!required_error
      end

      def default(&block)
        tap do
          reset_required
          @default_callable = block if block
        end
      end

      registry.add :default, key: key

      def default?
        !!default_callable
      end

      def null(&block)
        tap do
          @null_callable = block if block
        end
      end

      registry.add :null, key: key

      def null?
        !!null_callable
      end

      def coerce(&block)
        tap do
          default &block
          null &block
        end
      end

      registry.add :coerce, key: key

      def rename(from_key)
        tap do
          @rename_from = from_key
        end
      end

      registry.add :rename, key: key

      def renamed?
        !!rename_from
      end

      def loads(&block)
        tap do
          reflux { @loads_callable = block } if block
        end
      end

      registry.add :loads, key: key

      def dumps(&block)
        tap do
          reflux { @dumps_callable = block } if block
        end
      end

      registry.add :dumps, key: key

      # def readable(is_readable = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     reflux { @is_readable = !!is_readable }
      #   end
      # end

      # registry.add :readable, key: key

      # def writable(is_writable = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     reflux { @is_writable = !!is_writable }
      #   end
      # end

      # registry.add :writable, key: key

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
          loads: @loads_callable
          # loads: @loads_callable,
          # dumps: @dumps_callable
        )
      end

      def reset_required
        @required_error = nil
      end

      def reset_default
        @default_callable = nil
      end
    end
  end
end
