# frozen_string_literal: true

module Intention
  module Configuration
    module Initialization
      class AddAccessors
        def initialize(app)
          @app = app
        end

        def call(payload)
          payload.fetch(:intention).attributes.each do |name, attribute|
            attribute.define_getter
            attribute.define_setter
          end

          @app.call(payload)
        end
      end
    end
  end
end
