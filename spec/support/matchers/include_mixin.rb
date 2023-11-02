require_relative 'mixins/custom_matcher'

module Support
  module Matchers
    module IncludeMixin
      include Mixins::CustomMatcher

      match do |expected, target|
        target.include? expected
      end

      positive_failure do |expected, target|
        "expected #{target.inspect} to include mixin #{expected.inspect}"
      end

      negative_failure do |expected, target|
        "expected #{target.inspect} not to include mixin #{expected.inspect}"
      end
    end
  end
end
