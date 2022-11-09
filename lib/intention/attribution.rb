# frozen_string_literal: true

require_relative 'attribution/attribute'

module Intention
  module Attribution # rubocop:disable Style/Documentation
    class << self
      def included(base)
        base.extend ClassMethods

        base.send :mount_attributes_on_instance
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      private

      def attribute(name)
        attributes[name.to_sym]
      end

      def attributes
        @attributes ||= Hash.new { |h, name| h[name] = Attribute.new(class: self, name: name) }
      end

      def mount_attributes_on_instance
        local_attributes = attributes
        define_method(:attributes) { local_attributes }
        private :attributes
      end
    end
  end
end
