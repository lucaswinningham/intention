require_relative 'core/attribute'
require_relative 'core/configuration'
require_relative 'core/link'

# TODO: Allow `Intention.new(...) do ... end` like `Struct`
# TODO: Allow `Intention::Base` like `ActiveRecord::Base`

module Intention
  class << self
    def configure(&block)
      block&.call(configuration)
    end

    def configuration
      Configuration
    end

    def new(&block)
      Class.new do
        include Intention

        class_eval(&block)
      end
    end

    private

    def included(base)
      # TODO: `namespace` / `link` seems weird, needs better name
      link = Link.new(klass: base)

      base.define_singleton_method(:intention) { link }
      base.singleton_class.__send__(:private, :intention)

      base.define_method(:intention) { link }
      base.__send__(:private, :intention)

      base.extend(class_methods)
    end

    # rubocop:disable Metrics/MethodLength
    def class_methods
      Module.new do
        private

        def attribute(name)
          intention.attributes.proxies[name]
        end

        Attribute.registry.each do |entry_name|
          define_method entry_name do |attribute_name, *args, **kwargs, &block|
            attribute(attribute_name).public_send(entry_name, *args, **kwargs, &block)
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end

  def initialize(hash = {})
    # @intention_input = hash.transform_keys(&:to_sym)

    intention.initialization.call(input: hash, instance: self)
  end

  # # TODO: doesn't work!
  # # `Intention` included before configurations and
  # # changes therein are not honored on declaration of `Base` and
  # # by extension inherited classes also don't have access to configuration changes
  # class Base
  #   include Intention
  # end
end
