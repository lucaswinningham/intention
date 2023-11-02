module Intention
  module Configuration
    module AttributeInitialization
      class << self
        def middleware
          @middleware ||= Middleware::Builder.new
        end
      end
    end
  end
end
