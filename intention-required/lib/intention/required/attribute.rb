# frozen_string_literal: true

module Intention
  module Required
    module Attribute
      attr_reader :required_data

      def required?
        required_data.set?
      end
    end
  end
end
