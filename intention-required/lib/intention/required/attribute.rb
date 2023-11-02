require_relative 'data'

module Intention
  module Required
    module Attribute
      def required_data
        @required_data ||= Data.new
      end
    end
  end
end
