# frozen_string_literal: true

module Intention
  module Default
    module Attribute
      attr_reader :default_data

      def default?
        default_data.set?
      end
    end
  end
end
