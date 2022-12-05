# frozen_string_literal: true

require_relative 'attribution/attribute'

module Intention
  module Attribution # rubocop:disable Style/Documentation
    class << self
      private

      def included(base)
        base.extend ClassMethods

        mount_attributes base
      end

      def mount_attributes(base)
        local_attributes = base.__send__ :attributes

        base.define_method(:attributes) { local_attributes }
        base.__send__(:private, :attributes)
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      private

      def attribute(name)
        attributes[name.to_sym]
      end

      Attribute.registry.each do |entry_name|
        define_method entry_name do |attribute_name, *args, **kwargs, &block|
          attribute(attribute_name).public_send(entry_name, *args, **kwargs, &block)
        end
      end

      def attributes
        @attributes ||= Hash.new do |hash, name|
          hash[name] = Attribute.new(class: self, name: name)
        end
      end
    end
  end
end
