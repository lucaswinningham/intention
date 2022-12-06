# frozen_string_literal: true

module Intention
  module Attribution
    class Attribute
      module Accessors # rubocop:disable Style/Documentation
        class << self
          def define(options)
            return unless options.fetch(:accessible, true)

            define_getter(options)
            define_setter(options)
          end

          def undefine(options)
            undefine_getter(options)
            undefine_setter(options)
          end

          private

          def define_getter(options)
            klass = options.fetch(:class)
            name = options.fetch(:name)
            method_name = name
            readable = options.fetch(:readable)

            klass.define_method method_name do
              instance_variable_get(:"@#{name}")
            end

            klass.__send__(:private, method_name) unless readable
          end

          def define_setter(options)
            klass = options.fetch(:class)
            name = options.fetch(:name)
            method_name = "#{name}="
            loads = options.fetch(:loads)
            writable = options.fetch(:writable)

            klass.define_method method_name do |value|
              instance_variable_set(:"@#{name}", loads.call(value, self))
            end

            klass.__send__(:private, method_name) unless writable
          end

          def undefine_getter(options)
            klass = options.fetch(:class)
            name = options.fetch(:name)

            klass.__send__(:undef_method, name)
          rescue NameError
            nil
          end

          def undefine_setter(options)
            klass = options.fetch(:class)
            name = "#{options.fetch(:name)}="

            klass.__send__(:undef_method, name)
          rescue NameError
            nil
          end
        end
      end
    end
  end
end
