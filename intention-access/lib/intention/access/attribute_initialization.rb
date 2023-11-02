module Intention
  module Access
    class AttributeInitialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        attribute = payload.fetch(:attribute)

        attribute.getter.define
        attribute.setter.define
        attribute.accessible

        @app.call(payload)
      end
    end
  end
end
