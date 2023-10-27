# frozen_string_literal: true

require_relative 'attribute_initialization/add_accessors'

module Intention
  module Configuration
    module AttributeInitialization
      class << self
        def middleware
          @middleware ||= Middleware::Builder.new do
            use AddAccessors
          end
        end
      end
    end
  end
end
