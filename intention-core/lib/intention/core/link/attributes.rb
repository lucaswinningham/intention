# frozen_string_literal: true

module Intention
  module Link
    class Attributes # rubocop:disable Style/Documentation
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

      private

      def attributes
        @attributes ||= Hash.new do |hash, name|
          hash[name] = Intention::Attribute.new(intention: @intention, klass: @klass, name: name)
        end
      end
    end
  end
end
