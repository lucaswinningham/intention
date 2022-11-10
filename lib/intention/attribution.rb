# frozen_string_literal: true

require_relative 'attribution/attribute'

module Intention
  module Attribution # rubocop:disable Style/Documentation
    class << self
      def included(base)
        base.extend ClassMethods

        base.__send__ :mount_intention_attributes_hash_on_instance
      end
    end

    module ClassMethods # rubocop:disable Style/Documentation
      private

      def attribute(name)
        intention_attributes_hash[name.to_sym]
      end

      def intention_attributes_hash
        @intention_attributes_hash ||= Hash.new do |hash, name|
          hash[name] = Attribute.new(class: self, name: name)
        end
      end

      def mount_intention_attributes_hash_on_instance
        local_intention_attributes_hash = intention_attributes_hash

        define_method(:intention_attributes_hash) { local_intention_attributes_hash }
        private :intention_attributes_hash
      end
    end
  end
end
