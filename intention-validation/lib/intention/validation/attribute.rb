require_relative 'allow'
require_relative 'reject'
require_relative 'required'

module Intention
  module Validation
    module Attribute
      def required_data
        @required_data ||= Required::Data.new
      end

      def reject_data
        @reject_data ||= Reject::Data.new
      end

      def allow_data
        @allow_data ||= Allow::Data.new
      end
    end
  end
end
