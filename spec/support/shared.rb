# frozen_string_literal: true

module Support
  module Shared
    class << self
      def random_string(options = {})
        length = options.fetch(:length, 8)

        Array.new(length) { [*('a'..'z'), *('A'..'Z')].sample }.join
      end

      def random_attribute_name(options = {})
        random_string(options).then { |name| [true, false].sample ? name : name.to_sym }
      end

      def empty_natives
        [nil, [true, false].sample, '', :'', [], {}]
      end
    end
  end
end
