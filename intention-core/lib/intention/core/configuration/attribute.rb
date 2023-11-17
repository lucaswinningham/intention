module Intention
  module Configuration
    module Attribute
      class << self
        def register(name, &block)
          Intention::Attribute.registry.add(name)

          Intention::Attribute::Instance.define_method(name, &block)
          Intention::Attribute::Proxy.define_method(name) do |*args, **kwargs, &proxy_block|
            @attribute.public_send(name, *args, **kwargs, &proxy_block)
          end
        end

        def include(mod)
          Intention::Attribute::Instance.include(mod)
        end
      end
    end
  end
end
