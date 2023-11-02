require_relative 'default'
require_relative 'null'

module Intention
  module Ingestion
    module Attribute
      def default_data
        @default_data ||= Default::Data.new
      end

      def null_data
        @null_data ||= Null::Data.new
      end
    end
  end
end
