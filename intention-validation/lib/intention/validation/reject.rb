require_relative 'reject/setter'

module Intention
  module Validation
    class RejectedAttributeError < StandardError; end

    module Reject
      class BlockRequiredError < StandardError; end
    end
  end
end
