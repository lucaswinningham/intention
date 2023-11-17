require 'middleware'

module Intention
  module Support
    module Middleware
      class Builder < ::Middleware::Builder
        def upsert(middleware, ...)
          if (middleware_index = index(middleware))
            replace(middleware_index, middleware, ...)
          else
            use(middleware, ...)
          end
        end
      end
    end
  end
end
