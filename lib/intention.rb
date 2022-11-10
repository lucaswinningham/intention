# frozen_string_literal: true

require_relative 'intention/configuration'
require_relative 'intention/version'
require_relative 'intention/refinements'

module Intention # rubocop:disable Style/Documentation
  class << self
    def included(base)
      base.include Initialization
      base.include Attribution
      # base.include Mutation
    end

    def configure(&block)
      block&.call(config)
    end

    def config
      @config ||= Configuration.new
    end
  end
end

require_relative 'intention/attribution'
require_relative 'intention/initialization'
