# frozen_string_literal: true

require_relative 'initialization/set_values'

module Intention
  module Configuration
    module Initialization
      class << self
        def middleware
          @middleware ||= Middleware::Builder.new do
            use SetValues
          end
        end
      end
    end
  end
end