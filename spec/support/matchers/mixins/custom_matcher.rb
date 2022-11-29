# frozen_string_literal: true

using Intention::Refinements::StringRefinements::SnakeCase
using Intention::Refinements::StringRefinements::PascalCase

module Support
  module Matchers
    module Mixins
      module CustomMatcher
        class << self
          def included(base)
            base.extend ClassMethods
          end
        end

        module ClassMethods
          attr_reader :matcher_name

          def included(base)
            base.include InstanceMethods
          end

          module InstanceMethods; end

          def match(matcher_name = name.split('::').last, &match_block)
            @matcher_name = matcher_name.to_s.snake_case
            matcher_class.define_method :matches? do |target|
              @target = target

              match_block&.call(expected, target)
            end

            local_matcher_class = matcher_class
            InstanceMethods.define_method @matcher_name do |expected|
              local_matcher_class.new(expected)
            end
          end

          def positive_failure(&block)
            matcher_class.define_method :failure_message do
              block.call(expected, target)
            end
          end

          def negative_failure(&block)
            matcher_class.define_method :failure_message_when_negated do
              block.call(expected, target)
            end
          end

          def description(&block)
            matcher_class.define_method :description do
              block.call(expected, target)
            end
          end

          private

          def matcher_class
            @matcher_class ||= generate_default_matcher_class.tap do |klass|
              const_set(matcher_name.pascal_case, klass)
            end
          end

          def generate_default_matcher_class # rubocop:disable Metrics/MethodLength
            Class.new do
              attr_reader :expected, :target

              def initialize(expected)
                @expected = expected
              end

              def matches?(target)
                @target = target

                nil
              end

              def failure_message
                default_failure_proc.call
              end

              def failure_message_when_negated
                default_failure_proc.call
              end

              def description
                "target: #{@target.inspect}, expected: #{@expected.inspect}"
              end

              private

              def default_failure_proc
                @default_failure_proc ||= proc {
                  "expected: #{expected.inspect}, target: #{target.inspect}"
                }
              end
            end
          end
        end
      end
    end
  end
end
