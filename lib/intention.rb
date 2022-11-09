# frozen_string_literal: true

require_relative 'intention/version'

require_relative 'intention/attribution'

module Intention # rubocop:disable Style/Documentation
  class Error < StandardError; end

  class << self
    def included(base)
      base.include InstanceMethods
      base.include Attribution
    end
  end

  module InstanceMethods # rubocop:disable Style/Documentation
    def initialize(options_hash = {})
      @options_hash = options_hash

      initialize_intention
    end

    private

    attr_reader :options_hash

    def initialize_intention(hash = options_hash)
      attributes.each do |name, attribute|
        value = hash.fetch(attribute.name) { hash.fetch(attribute.name.to_s, nil) }

        if value.nil?
          raise(attribute.required_error, nil.inspect) if attribute.required?

          value = attribute.default_value
        end

        send("#{name}=", value)
      end
    end
  end
end
