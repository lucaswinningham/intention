module Intention
  module Configuration
    module Initialization
      class << self
        def middleware
          @middleware ||= Support::Middleware::Builder.new
        end
      end
    end
  end
end
