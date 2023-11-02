require_relative 'required'

module Intention
  module Validation
    module Attribute
      def required_data
        @required_data ||= Required::Data.new
      end
    end
  end
end
