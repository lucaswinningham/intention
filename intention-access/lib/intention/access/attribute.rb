require_relative 'attribute/accessor'
require_relative 'attribute/decorated_klass'

# TODO: needs tests
module Intention
  module Access
    module Attribute
      def klass
        @decorated_klass ||= DecoratedKlass.new(@klass)
      end

      def accessor
        @accessor ||= Accessor.new(klass: klass, name: name, attribute: self)
      end

      # TODO: test
      def readable?
        klass.any_method_defined?(accessor.getter.name)
      end

      # TODO: test
      def writable?
        klass.any_method_defined?(accessor.setter.name)
      end
    end
  end
end
