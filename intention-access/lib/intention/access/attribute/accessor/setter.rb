require 'middleware'

module Intention
  module Access
    module Attribute
      module Accessor
        class Setter
          def initialize(options = {})
            @klass = options.fetch(:klass)
            @name = options.fetch(:name)
          end

          def name
            @setter_name ||= "#{@name}="
          end

          def define
            instance_variable_name = Accessor.instance_variable_name(@name)
            setter_stack = middleware

            @klass.define_method(name) do |value|
              instance_variable_set(instance_variable_name, setter_stack.call(value: value))
            end
          end

          def middleware
            @middleware ||= Middleware::Builder.new do
              use(IdentityMiddleware)
            end
          end

          class IdentityMiddleware
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
