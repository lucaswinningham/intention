# frozen_string_literal: true

require_relative 'intention/configuration'
require_relative 'intention/version'
require_relative 'intention/refinements'

require_relative 'intention/error'

require_relative 'intention/initialization'
require_relative 'intention/attribution'
require_relative 'intention/serialization'
require_relative 'intention/strict'

module Intention # rubocop:disable Style/Documentation
  class << self
    def configure(&block)
      block&.call(config)
    end

    private

    def config
      @config ||= Configuration.new
    end

    def included(base)
      base.include Attribution
      base.include Initialization
      base.include Serialization
      base.include Strict
      # base.include Mutation # "dirty"
    end
  end
end

Intention::Attribute.include Intention::Ingestion::Attribute::Configuration
Intention::Instance.include Intention::Ingestion::Instance::Configuration
