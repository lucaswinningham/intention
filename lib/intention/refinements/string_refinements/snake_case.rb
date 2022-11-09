# frozen_string_literal: true

require_relative 'split_case'

using Intention::Refinements::StringRefinements::SplitCase

module Intention
  module Refinements
    module StringRefinements
      module SnakeCase # rubocop:disable Style/Documentation
        refine String do
          def snake_case
            split_case.join('_')
          end
        end
      end
    end
  end
end
