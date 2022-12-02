# frozen_string_literal: true

module Support
  module Shared
    class Open
      def method_missing(...); end

      def respond_to_missing?(...)
        true
      end
    end
  end
end
