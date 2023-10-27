# frozen_string_literal: true

# require_relative 'initialization/add_accessors'

module Intention
  module Configuration
    module Attribute
      class << self
        def register(name, &block)
          Intention::Attribute.registry.add(name)

          Intention::Attribute::Instance.define_method(name, &block)
          Intention::Attribute::Proxy.define_method(name) do |*args, **kwargs, &block|
            @attribute.public_send(name, *args, **kwargs, &block)
          end
        end

        def include(mod)
          Intention::Attribute::Instance.include(mod)
        end
      end
    end
  end
end
