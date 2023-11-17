module Intention
  module Access
    module Attribute
      module Accessor
        class Getter
          def initialize(options = {})
            @accessor = options.fetch(:accessor)
          end

          def name
            @name ||= @accessor.name
          end

          def define
            instance_variable_name = @accessor.instance_variable_name

            @accessor.klass.define_method(name) do
              instance_variable_get(instance_variable_name)
            end
          end
        end
      end
    end
  end
end
