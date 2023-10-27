# frozen_string_literal: true

require 'intention/core'

module Intention
  module Writeonly
    class << self
      def configure
        @configured ||= begin
          Intention.configure do |configuration|
            configuration.attribute.register(:writeonly) do |*args, **kwargs, &block|
              tap do
                tap do
                  @klass.__send__(:private, @name)
                  @klass.__send__(:public, "#{@name}=")
                end
              end
            end
          end

          :writeonly_configured
        end
      end
    end
  end
end
