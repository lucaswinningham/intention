# frozen_string_literal: true

require_relative 'intention/configuration'
require_relative 'intention/attribution'
require_relative 'intention/link'

module Intention # rubocop:disable Style/Documentation
  class << self
    def configure(&block)
      block&.call(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    private

    def included(base)
      base.extend ClassMethods

      # TODO: `namespace` / `link` seems weird, needs better name
      link = Link.new
      link.define_singleton_method(:attributes) { base.__send__ :intention_attributes }

      base.define_method(:intention) { link }
      base.__send__(:private, :intention)

      base.include InstanceMethods
    end
  end

  module ClassMethod
    def attribute(name)
      intention_attributes[name.to_sym]
    end

    private

    def intention_attributes
      @intention_attributes ||= Hash.new do |hash, name|
        hash[name] = Attribute.new(class: self, name: name)
      end
    end
  end

  module InstanceMethods
    def initialize(hash = {})
      initialize_intention(hash)
    end

    private

    attr_reader :intention_input

    def initialize_intention(hash = {})
      # @intention_input = hash.transform_keys(&:to_sym)

      # intention.each_attribute do |attribute|
      #   block.call(input: intention_input, attribute: attribute)
      # end
      Intention.configuration.initialization.call({
        instance: self,
        input: hash,
        intention: intention,
      })
    end
  end
end
