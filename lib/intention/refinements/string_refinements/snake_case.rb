require_relative 'split_case'

using Intention::Refinements::StringRefinements::SplitCase

module Intention
  module Refinements
    module StringRefinements
      module SnakeCase
        refine String do
          def snake_case
            split_case.join('_')
          end
        end
      end
    end
  end
end
