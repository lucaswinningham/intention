module Intention
  module Ingestion
    class Data
      def set?
        @set
      end

      def set
        @set = true
      end
    end
  end
end
