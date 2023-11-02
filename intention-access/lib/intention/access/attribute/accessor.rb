require_relative 'accessor/getter'
require_relative 'accessor/setter'

module Intention
  module Access
    module Attribute
      module Accessor
        class << self
          def instance_variable_name(name)
            :"@#{name}"
          end

          def getter(...)
            Getter.new(...)
          end

          def setter(...)
            Setter.new(...)
          end
        end
      end
    end
  end
end
