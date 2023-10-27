# frozen_string_literal: true

require 'intention/core'

require 'intention/default'
require 'intention/null'

module Intention
  module Coerce
    class << self
      def configure
        @configured ||= begin
          Intention::Default.configure
          Intention::Null.configure

          Intention.configure do |configuration|
            configuration.attribute.register(:coerce) do |*args, **kwargs, &block|
              default(*args, **kwargs, &block).null(*args, **kwargs, &block)
            end
          end

          :coerce_configured
        end
      end
    end
  end
end
