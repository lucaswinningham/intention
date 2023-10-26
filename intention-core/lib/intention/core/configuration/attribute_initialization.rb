# frozen_string_literal: true

module Intention
  module Configuration
    module AttributeInitialization
      class << self
        def middleware
          @middleware ||= Middleware::Builder.new do
          end
        end
      end
    end
  end
end
