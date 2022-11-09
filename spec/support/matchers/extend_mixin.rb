# frozen_string_literal: true

require_relative 'mixins/custom_matcher'

module Support
  module Matchers
    module ExtendMixin
      include Mixins::CustomMatcher

      match do |expected, target|
        target.singleton_class.include? expected
      end

      positive_failure do |expected, target|
        "expected #{target.inspect} to extend mixin #{expected.inspect}"
      end

      negative_failure do |expected, target|
        "expected #{target.inspect} not to extend mixin #{expected.inspect}"
      end
    end
  end
end
