module Intention
  module Access
    module Attribute
      module Accessor
        class Setter
          def initialize(options = {})
            @accessor = options.fetch(:accessor)
            @attribute = options.fetch(:attribute)
          end

          def name
            @name ||= "#{@accessor.name}="
          end

          def define
            instance_variable_name = @accessor.instance_variable_name
            setter_stack = middleware
            local_attribute_reference = @attribute

            @accessor.klass.define_method(name) do |value|
              instance_variable_set(
                instance_variable_name,
                setter_stack.call(value: value, attribute: local_attribute_reference),
              )
            end
          end

          def middleware
            @middleware ||= Support::Middleware::Builder.new { use(ReturnValue) }
          end

          class ReturnValue
            def initialize(app)
              @app = app
            end

            def call(payload = {})
              @app.call(payload)

              payload.fetch(:value)
            end
          end
        end
      end
    end
  end
end
