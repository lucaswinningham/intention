module Intention
  module Attribute
    class Instance
      # class NameRequiredError < Error; end
      # class UnparsableNameError < Error; end

      attr_reader :name

      def initialize(options = {})
        @klass = options.fetch(:klass)
        # @name = sanitize_name options.fetch(:name) { raise NameRequiredError }
        @name = options.fetch(:name)
        @intention = options.fetch(:intention)

        @intention.attribute_initialization.call(attribute: self, klass: @klass)
      end

      # TODO: orthoganality here with `input_accessor` / `given_in?` / `value_in`?
      def input_accessor
        @input_accessor ||= name
      end

      def given_in?(input)
        input.key?(input_accessor)
      end

      def value_in(input, ...)
        input.fetch(input_accessor, ...)
      end

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

      # def withheld?
      #   !!is_withheld
      # end

      # def coerce(&block)
      #   default(&block).null(&block)
      # end

      # def hidden(is_hidden = true)
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
    end
  end
end
