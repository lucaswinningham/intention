# frozen_string_literal: true

module Intention
  module Attribute
    class Instance # rubocop:disable Style/Documentation
      # class NameRequiredError < Error; end
      # class UnparsableNameError < Error; end

      attr_reader :name

      def initialize(options = {})
        @klass = options.fetch(:klass)
        # @name = sanitize_name options.fetch(:name) { raise NameRequiredError }
        @name = options.fetch(:name)
        @intention = options.fetch(:intention)

        @intention.attribute_initialization.call(attribute: self, intention: @intention)

        # @is_accessible = true
        # @is_readable = true
        # @is_writable = true

        # reflux
      end

      # TODO: orthoganality here with `input_accessor` / `given_in?` / `value_in`?
      def input_accessor
        @input_accessor ||= name
      end

      def given_in?(input)
        input.key?(input_accessor)
      end

      def value_in(input, *args, **kwargs, &block)
        input.fetch(input_accessor, *args, **kwargs, &block)
      end

      # TODO: orthoganality here with `define` / `define_getter` / `define_setter`?
      def define(method_name, options = {}, &block)
        @klass.undef_method(method_name) if @klass.method_defined?(method_name)

        @klass.define_method(method_name, &block)

        @klass.__send__(:private, method_name) if options.fetch(:private, false)
      end

      def define_getter(options = {})
        block ||= proc { |x| x }
        local_name = name

        define(name, options) do
          block.call(instance_variable_get(:"@#{local_name}"))
        end
      end

      def define_setter(options = {}, &block)
        block ||= proc { |x| x }
        local_name = name

        define("#{name}=", options) do |value|
          instance_variable_set(:"@#{local_name}", block.call(value))
        end
      end

      # def hash_accessor
      #   renamed? ? renamed_from : name
      # end

      # def null(&block)
      #   tap do
      #     @null_callable = block if block
      #   end
      # end

      # def nullable?
      #   !!null_callable
      # end

      # def renamed(from_key)
      #   tap do
      #     @renamed_from = from_key
      #   end
      # end

      # def renamed?
      #   !!renamed_from
      # end

      # def loads(&block)
      #   tap do
      #     reflux { @loads_callable = block } if block
      #   end
      # end

      # def loads_callable
      #   @loads_callable ||= proc { |value| value }
      # end

      # def dumps(&block)
      #   tap do
      #     @dumps_callable = block if block
      #   end
      # end

      # def dumps_callable
      #   @dumps_callable ||= proc { |value| value }
      # end

      # def accessible(is_accessible = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     reflux { @is_accessible = !!is_accessible }
      #   end
      # end

      # def accessible?
      #   @is_accessible
      # end

      # def readable(is_readable = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     reflux { @is_readable = !!is_readable }
      #   end
      # end

      # def readable?
      #   @is_readable
      # end

      # def writable(is_writable = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     reflux { @is_writable = !!is_writable }
      #   end
      # end

      # def writable?
      #   @is_writable
      # end

      # def withheld(is_withheld = true) # rubocop:disable Style/OptionalBooleanParameter
      #   tap do
      #     @is_withheld = !!is_withheld
      #   end
      # end

      # def withheld?
      #   !!is_withheld
      # end

      # def coerce(&block)
      #   default(&block).null(&block)
      # end

      # def hidden(is_hidden = true) # rubocop:disable Style/OptionalBooleanParameter
      #   withheld(is_hidden).readable(!is_hidden).writable(!is_hidden)
      # end

      # def expected
      #   accessible(false).withheld
      # end

      # def field(&block)
      #   default(&block).hidden
      # end

      # private

      # def sanitize_name(name)
      #   name.to_sym
      # rescue NoMethodError
      #   raise UnparsableNameError, name.inspect
      # end

      # def reflux(&block)
      #   Accessors.undefine(class: @klass, name: name)

      #   block&.call

      #   Accessors.define(
      #     class: @klass,
      #     name: name,
      #     accessible: accessible?,
      #     readable: readable?,
      #     writable: writable?,
      #     loads: loads_callable
      #   )
      # end

      # def reset_required
      #   @required_error = nil
      #   @required_callable = nil
      # end

      # def reset_default
      #   @default_callable = nil
      # end
    end
  end
end
