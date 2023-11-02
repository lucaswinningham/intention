module Intention
  module Access
    module Attribute
      module Accessor
        class Getter
          attr_reader :name

          def initialize(options = {})
            @klass = options.fetch(:klass)
            @name = options.fetch(:name)
          end

          def define
            instance_variable_name = Accessor.instance_variable_name(@name)

            @klass.define_method(name) do
              instance_variable_get(instance_variable_name)
            end
          end
        end
      end
    end
  end
end
