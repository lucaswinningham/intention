module Intention
  module Refinements
    module StringRefinements
      module SplitCase
        refine String do
          def split_case
            (self == upcase ? self : gsub(/([[:upper:]])/, '_\1')).then do |s|
              s.tr(' ', '_').tr('-', '_').downcase.split('_').reject(&:empty?)
            end
          end
        end
      end
    end
  end
end
