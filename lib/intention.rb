# frozen_string_literal: true

require_relative 'intention/configuration'
require_relative 'intention/version'
require_relative 'intention/refinements'

require_relative 'intention/error'
require_relative 'intention/initialization'
require_relative 'intention/attribution'
require_relative 'intention/serialization'
require_relative 'intention/strict'
require_relative 'intention/dirty'

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
      base.include Initialization
      base.include Attribution
      base.include Serialization
      base.include Strict
      base.include Dirty
    end
  end
end
