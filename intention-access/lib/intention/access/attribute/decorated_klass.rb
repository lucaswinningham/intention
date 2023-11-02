require 'delegate'

module Intention
  module Access
    module Attribute
      class DecoratedKlass < SimpleDelegator
        def klass
          @klass ||= __getobj__
        end

        def any_method_defined?(method_name)
          method_defined?(method_name) || private_method_defined?(method_name)
        end

        def undefine_method(method_name)
          undef_method(method_name) if any_method_defined?(method_name)
        end

        def publicize_method(method_name)
          klass.__send__(:public, method_name) if any_method_defined?(method_name)
        end

        def privatize_method(method_name)
          klass.__send__(:private, method_name) if any_method_defined?(method_name)
        end
      end
    end
  end
end
