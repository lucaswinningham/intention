require_relative 'accessor/instance'

module Intention
  module Access
    module Attribute
      module Accessor
        class << self
          def new(...)
            Instance.new(...)
          end
        end
      end
    end
  end
end
