# frozen_string_literal: true

require 'intention/middleware'

module Intention
  class Configuration
    module Middleware
      module Initialization
        class AddAccessors
          include ::Middleware

          run do |payload, &block|
            instance = payload.fetch(:instance)
            intention = payload.fetch(:intention)

            intention.attributes.each do |name, attribute|
              value = intention.valuation.call(payload.merge(attribute: attribute))
              instance.__send__("#{name}=", value)
            end

            block.call(payload)
          end
        end
      end
    end
  end
end