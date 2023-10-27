# frozen_string_literal: true

module Intention
  module Null
    module Attribute
      attr_reader :null_data

      def null?
        null_data.set?
      end
    end
  end
end
