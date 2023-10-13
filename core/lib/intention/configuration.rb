# frozen_string_literal: true

require_relative 'middleware'
require_relative 'configuration/middleware'

module Intention
  class Configuration
    def initialize(options = {})
      @readonly = options.fetch(:readonly, false)
    end

    def copy
      self.class.new(readonly: true)
    end

    def initialization
      @initialization ||= ::Middleware::Chain.new do |chain|
        chain.add(Middleware::Initialization::AddAccessors)
      end
    end

    private

    attr_reader :readonly
  end
end
