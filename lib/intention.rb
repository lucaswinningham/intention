# frozen_string_literal: true

require_relative 'intention/version'
require_relative 'intention/macros'

module Intention
  class Error < StandardError; end

  class << self
    def included(base)
      base.include InstanceMethods
      base.extend ClassMethods
    end
  end

  module InstanceMethods
    def initialize(hash = {})
      @hash = hash

      initialize_attributes @hash
    end

    private

    attr_reader :hash

    def initialize_attributes(attributes_hash = {})
      attributes.each do |name, config|
        value = attributes_hash.fetch(name) { attributes_hash.fetch(name.to_s, nil) }

        if value.nil?
          raise(config.fetch(:error), nil.inspect) if config.fetch(:required)

          value = config.fetch(:default)
        end

        send("#{name}=", value)
      end
    end
  end

  module ClassMethods
    include Macros

    class ValueError < Intention::Error; end

    class << self
      def extended(base)
        base.send(:attributes) # Initial call to populate @attributes and define_method :attributes
      end
    end

    IDENTITY = ->(x) { x }.freeze

    def attribute(name, options = {})
      default = options.fetch(:default, nil)
      required = options.fetch(:required, false)
      error = options.fetch(:error, ValueError)

      attributes[name.to_sym].merge!(required: required, error: error, default: default)

      define_getter(name.to_sym, options)
      define_setter(name.to_sym, options)
    end

    private

    def attributes
      @attributes ||= Hash.new { |hash, name| hash[name.to_sym] = {} }.tap do |hash|
        define_method :attributes do
          hash
        end

        private :attributes
      end
    end

    def define_getter(name, options = {})
      dumps = options.fetch(:dumps, IDENTITY)
      readable = options.fetch(:readable, false)
      method_name = name

      define_method name do
        dumps.call instance_variable_get(:"@#{name}")
      end

      private method_name unless readable
    end

    def define_setter(name, options = {})
      loads = options.fetch(:loads, IDENTITY)
      writable = options.fetch(:writable, false)
      method_name = "#{name}="

      define_method method_name do |value|
        instance_variable_set(:"@#{name}", loads.call(value))
      end

      private method_name unless writable
    end
  end
end
