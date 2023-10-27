# frozen_string_literal: true

module Intention
  module Configuration
    module AttributeInitialization
      class AddAccessors
        def initialize(app)
          @app = app
        end

        def call(payload)
          payload.fetch(:klass).__send__(:attr_accessor, payload.fetch(:attribute).name)

          @app.call(payload)
        end
      end
    end
  end
end
