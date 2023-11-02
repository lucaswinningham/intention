require_relative 'mixins/custom_matcher'

module Support
  module Matchers
    module HaveMethod
      include Mixins::CustomMatcher

      match do |expected, target|
        target.respond_to?(expected, true)
      end

      description do |expected|
        "have method ##{expected}"
      end

      positive_failure do |expected, target|
        "expected #{target.inspect} to have defined method #{expected.inspect}"
      end

      negative_failure do |expected, target|
        "expected #{target.inspect} not to have defined method #{expected.inspect}"
      end
    end
  end
end
