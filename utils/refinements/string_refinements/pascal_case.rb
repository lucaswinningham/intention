require_relative 'split_case'

using Intention::Refinements::StringRefinements::SplitCase

module Intention
  module Refinements
    module StringRefinements
      module PascalCase
        refine String do
          def pascal_case
            split_case.map(&:capitalize).join
          end
        end
      end
    end
  end
end
