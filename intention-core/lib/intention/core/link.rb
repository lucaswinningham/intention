# frozen_string_literal: true

require_relative 'link/instance'

module Intention
  module Link # rubocop:disable Style/Documentation
    class << self
      def new(*args, **kwargs, &block)
        Instance.new(*args, **kwargs, &block)
      end
    end
  end
end
