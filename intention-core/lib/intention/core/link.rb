require_relative 'link/instance'

module Intention
  module Link
    class << self
      def new(...)
        Instance.new(...)
      end
    end
  end
end
