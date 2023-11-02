module Intention
  module Initialization
    module VerifyInputHash
      class << self
        def call(options = {})
          input_hash = options.fetch(:input_hash).transform_keys(&:to_sym)
          attributes = options.fetch(:attributes)

          unexpected_keys = input_hash.keys - attributes.values.map(&:hash_accessor)

          return unless unexpected_keys.any?

          raise Intention::UnexpectedKeysError, unexpected_keys.map(&:inspect).join(', ')
        end
      end
    end
  end
end
