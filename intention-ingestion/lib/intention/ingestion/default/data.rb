module Intention
  module Ingestion
    module Default
      class Data
        def set?
          !!@set
        end

        def set(&block)
          @callable = block

          @set = true
        end

        def call(...)
          @callable.call(...)
        end
      end
    end
  end
end
