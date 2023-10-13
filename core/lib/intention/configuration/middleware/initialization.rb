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

            # do stuff

            block.call(payload)
          end
        end
      end
    end
  end
end