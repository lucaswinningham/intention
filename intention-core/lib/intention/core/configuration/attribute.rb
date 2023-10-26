# frozen_string_literal: true

# require_relative 'initialization/add_accessors'

module Intention
  module Configuration
    module Attribute
      class << self
        def register(name, &block)
          Intention::Attribute.registry.add(name)

          Intention::Attribute::Instance.define_method(name, &block)
        end

        def include(mod)
          Intention::Attribute::Instance.include(mod)
        end
      end
    end
  end
end
