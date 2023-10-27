# frozen_string_literal: true

require_relative 'data'

module Intention
  module Null
    class AttributeInitialization
      def initialize(app)
        @app = app
      end

      def call(payload)
        payload.fetch(:attribute).instance_variable_set(:@null_data, Data.new)

        @app.call(payload)
      end
    end
  end
end
