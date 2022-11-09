# frozen_string_literal: true

module Intention
  class Configuration # rubocop:disable Style/Documentation
    class Error < StandardError; end
    class UnparsableNameError < Error; end

    def instance_input_hash_name=(name)
      @instance_input_hash_name = name.to_sym
      name.to_sym
    rescue NoMethodError
      raise UnparsableNameError, name.inspect
    end

    def instance_input_hash_name
      @instance_input_hash_name ||= :input_hash
    end
  end
end
