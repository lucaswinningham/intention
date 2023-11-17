require_relative 'allow/setter'

module Intention
  module Validation
    class AllowedAttributeError < StandardError; end

    module Allow
      class BlockRequiredError < StandardError; end
    end
  end
end
