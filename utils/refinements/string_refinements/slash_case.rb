require_relative 'split_case'

using Intention::Refinements::StringRefinements::SplitCase

module Intention
  module Refinements
    module StringRefinements
      module SlashCase
        refine String do
          def slash_case
            split_case.join('/')
          end
        end
      end
    end
  end
end
