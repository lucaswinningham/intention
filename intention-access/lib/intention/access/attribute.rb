require_relative 'attribute/accessor'
require_relative 'attribute/decorated_klass'

# TODO: needs tests
module Intention
  module Access
    module Attribute
      def klass
        @decorated_klass ||= DecoratedKlass.new(@klass)
      end

      def getter
        @getter ||= Accessor.getter(klass: klass, name: name)
      end

      def setter
        @setter ||= Accessor.setter(klass: klass, name: name)
      end
    end
  end
end
