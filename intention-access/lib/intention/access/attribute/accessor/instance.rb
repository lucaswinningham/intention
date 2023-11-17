require_relative 'getter'
require_relative 'setter'

module Intention
  module Access
    module Attribute
      module Accessor
        Instance = Struct.new(:klass, :name, :attribute, keyword_init: true) do
          def instance_variable_name
            @instance_variable_name ||= :"@#{name}"
          end

          def getter
            @getter ||= Getter.new(accessor: self)
          end

          def setter
            @setter ||= Setter.new(accessor: self, attribute: attribute)
          end
        end
      end
    end
  end
end
