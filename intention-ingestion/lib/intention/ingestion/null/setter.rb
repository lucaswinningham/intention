module Intention
  module Ingestion
    module Null
      class Setter
        def initialize(app, &block)
          @app = app
          @block = block
        end

        def call(payload)
          value = payload.fetch(:value)

          payload[:value] = @block.call(value) if value.nil?

          @app.call(payload)
        end
      end
    end
  end
end
