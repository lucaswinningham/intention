module Intention
  module Configuration
    module Initialization
      class << self
        def middleware
          @middleware ||= Middleware::Builder.new
        end
      end
    end
  end
end
