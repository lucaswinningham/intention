module Intention
  module Configuration
    module AttributeInitialization
      class << self
        def middleware
          @middleware ||= Support::Middleware::Builder.new
        end
      end
    end
  end
end
