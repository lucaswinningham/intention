module Intention
  module Ingestion
    module Loads
      class Setter
        def initialize(app, &block)
          @app = app
          @block = block
        end

        def call(payload)
          value = payload.fetch(:value)

          payload[:value] = @block.call(value)

          @app.call(payload)
        end
      end
    end
  end
end
