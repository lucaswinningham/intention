# frozen_string_literal: true

module Intention
  module Macros
    def attribute(...)
      raise NotImplementedError
    end

    def required(name, options = {})
      attribute(name, options.merge(required: true))
    end

    def readable(name, options = {})
      attribute(name, options.merge(readable: true))
    end

    def writable(name, options = {})
      attribute(name, options.merge(writable: true))
    end

    # def boolean(name, options = {})
    #   member(name, [nil, true, false], options)
    # end
  end
end
