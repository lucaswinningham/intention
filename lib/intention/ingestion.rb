module Intention
  class Entries
    def add(block)
      entries.push(block)
    end

    def each(&block)
      entries.each(&block)
    end

    private

    def entries
      @entries ||= []
    end
  end
end

module Intention
  class Attribute
    class NameRequiredError < StandardError; end

    module Configuration
      class << self
        private

        def included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def on_init(&block)
          Attribute.initialization.add(block)
        end
      end
    end

    attr_reader :name

    def initialize(name)
      @name = name.to_sym

      self.class.initialization.each do |block|
        block.call(self)
      end
    end

    def set(var_name, value)
      instance_variable_set(:"@#{var_name}", value)
    end

    def get(var_name)
      instance_variable_get(:"@#{var_name}")
    end

    class << self
      def initialization
        @initialization ||= Intention::Entries.new
      end

      def register(name, &block)
        Attribute.define_method(name) do |*args, **kwargs, &method_block|
          tap do
            block.call(*args, **kwargs, &method_block)
          end
        end
      end

      private

      def registration
        @registration ||= {}
      end
    end
  end
end

module Intention
  class RequiredAttributeError < StandardError; end

  module Ingestion
    module Attribute
      module Configuration
        include Intention::Attribute::Configuration

        Default = Struct.new(:callable, keyword_init: true) do
          def set(options = {})
            @callable = options.fetch(:callable, nil)
          end
      
          def set?
            !!callable
          end
      
          def reset
            @callable = nil
          end
        end
      
        Required = Struct.new(:error_class, :callable, keyword_init: true) do
          def set(options = {})
            @error_class = options.fetch(:error_class)
            @callable = options.fetch(:callable) || proc { true }
          end
      
          def set?
            !!error_class && !!callable
          end
      
          def reset
            @error_class = nil
            @callable = nil
          end
        end

        on_init do |attribute|
          attribute.set(:required, Required.new)
          attribute.set(:default, Default.new)
        end

        register :required do |error_class = RequiredAttributeError, &block|
          get(:default).reset
          get(:required).set(error_class: error_class, callable: block)
        end

        register :default do |&block|
          get(:required).reset
          get(:default).set(callable: block)
        end
      end
    end
  end
end

module Intention
  class Instance # TODO: change name here
    class InstanceIntention
      def initialize(options = {})
        @attributes = options.fetch(:attributes)
      end

      def each_attribute(&block)
        attributes.call.each_value(&block)
      end

      private

      attr_reader :attributes
    end

    class << self
      private

      def included(base)
        base.extend(ClassMethods)

        base.define_method(:intention) do
          InstanceIntention.new(attributes: proc { base.__send__(:attributes) })
        end

        base.__send__(:private, :intention)

        base.include(InstanceMethods)
      end
    end

    module InstanceMethods
      def initialize(hash = {})
        @intention_input = hash.transform_keys(&:to_sym)

        intention.each_attribute do |attribute|
          block.call(input: intention_input, attribute: attribute)
        end
      end

      private

      attr_reader :intention_input
    end

    module ClassMethods
      def attribute(name)
        attributes[name.to_sym]
      end

      private

      def attributes
        @attributes ||= Hash.new do |hash, name|
          hash[name] = Intention::Attribute.new(name)
        end
      end
    end

    module Configuration
      class << self
        private

        def included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def on_init(&block)
          Instance.initialization.add(block)
        end

        def register(name, &block)
          Instance.define_singleton_method(name) do |attribute_name, ...|
            attribute(attribute_name).public_send(entry_name, ...)
          end
        end
      end
    end

    class << self
      def initialization
        @initialization ||= Intention::Entries.new
      end
    end
  end
end

module Intention
  class RequiredAttributeError < StandardError; end

  module Ingestion
    module Instance
      module Configuration
        include Intention::Instance::Configuration

        on_init do |instance, options = {}|
          attribute = options.fetch(:attribute)

          unless options.fetch(:input).key?(attribute.hash_accessor) # TODO: implement
            required = attribute.get(:required)

            if required.set? && required.callable.call(instance)
              raise required.error_class
            end
          end
        end

        on_init do |instance, options = {}|
          attribute = options.fetch(:attribute)

          unless options.fetch(:input).key?(attribute.hash_accessor) # TODO: implement
            default = attribute.get(:default)

            if default.set?
              instance.__send__("#{attribute.name}=", default.callable.call(instance))
            end
          end
        end

        # This seems silly, find a way to merge the two?
        register(:required)
        register(:default)
      end
    end
  end
end

configuration.initialization.add do |options = {}|
  attribute = options.fetch(:attribute)
  config = attribute.configuration
  input_hash = options.fetch(:input_hash)
  instance = options.fetch(:instance)

  unless input_hash.key? attribute.hash_accessor
    if config.required? && config.required.callable.call(instance)
      raise config.required.error
    end

    value = config.default.callable.call(instance) if config.default?

    instance.__send__("#{attribute.name}=", value)
  end

  block.call(attribute, input_hash)
end