# frozen_string_literal: true

require 'intention/core'

# TODO: Keep around for loads / dumps

# > class Klass
# >   def pub; end
# >     private
# >     def prv; end
# > end
# > Klass.method_defined? :pub
#  => true
# > Klass.method_defined? :prv
#  => false
# > Klass.private_method_defined? :pub
#  => false
# > Klass.private_method_defined? :prv
#  => true

module Intention
  module Readonly
    class << self
      def configure
        @configured ||= begin
          Intention.configure do |configuration|
            configuration.attribute.register(:readonly) do
              tap do
                @klass.__send__(:public, @name)
                @klass.__send__(:private, "#{@name}=")
              end
            end
          end

          :readonly_configured
        end
      end
    end
  end
end
