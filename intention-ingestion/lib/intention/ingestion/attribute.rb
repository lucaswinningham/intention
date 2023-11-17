require_relative 'default'

module Intention
  module Ingestion
    module Attribute
      def default_data
        @default_data ||= Default::Data.new
      end
    end
  end
end
