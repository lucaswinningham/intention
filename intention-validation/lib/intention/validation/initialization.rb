module Intention
  module Validation
    class Initialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        process_required_attributes(payload)

        @app.call(payload)
      end

      private

      def process_required_attributes(payload)
        target_attributes(payload).each do |attribute|
          attribute.required_data.raise!
        end
      end

      def target_attributes(payload)
        input = payload.fetch(:input)

        payload.fetch(:intention).attributes.filter do |attribute|
          !attribute.given_in?(input) && attribute.required_data.set?
        end
      end
    end
  end
end
