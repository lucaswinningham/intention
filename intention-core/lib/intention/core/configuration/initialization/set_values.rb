# frozen_string_literal: true

module Intention
  module Configuration
    module Initialization
      class SetValues
        def initialize(app)
          @app = app
        end

        def call(payload)
          input = payload.fetch(:input)
          instance = payload.fetch(:instance)

          payload.fetch(:intention).attributes.each do |name, attribute|
            next unless attribute.given_in?(input)

            instance.__send__("#{name}=", attribute.value_in(input))
          end

          @app.call(payload)
        end
      end
    end
  end
end
