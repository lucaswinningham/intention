require_relative 'split_case'

using Intention::Refinements::StringRefinements::SplitCase

module Intention
  module Refinements
    module StringRefinements
      module KebabCase
        refine String do
          def kebab_case
            split_case.join('-')
          end
        end
      end
    end
  end
end
