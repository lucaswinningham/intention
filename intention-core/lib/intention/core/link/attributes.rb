module Intention
  module Link
    class Attributes
      def initialize(options = {})
        @intention = options.fetch(:intention)
        @klass = options.fetch(:klass)
      end

      def proxies
        @proxies ||= Hash.new do |hash, name|
          hash[name] = Intention::Attribute.proxy(attributes[name])
        end
      end

      def each(&block)
        attributes.each(&block)
      end

      def names
        attributes.keys
      end

      private

      # TODO: set up mechanism (middleware?) for when attribute is added so
      # TODO: we can query like `attributes.required` (for Initialization speed up)
      def attributes
        @attributes ||= Hash.new do |hash, name|
          hash[name] = Intention::Attribute.new(intention: @intention, klass: @klass, name: name)
        end
      end
    end
  end
end
