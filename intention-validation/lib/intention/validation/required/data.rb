module Intention
  module Validation
    module Required
      class Data
        def set?
          @set
        end

        def set(error_klass = RequiredAttributeError)
          @error_klass = error_klass

          @set = true
        end

        def raise!
          raise @error_klass
        end
      end
    end
  end
end
