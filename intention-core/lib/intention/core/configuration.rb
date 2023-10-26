# frozen_string_literal: true

require 'middleware'

require_relative 'configuration/attribute'
require_relative 'configuration/attribute_initialization'
require_relative 'configuration/initialization'

module Intention
  module Configuration
    class << self
      def attribute
        Attribute
      end

      def attribute_initialization
        @attribute_initialization ||= AttributeInitialization.middleware
      end

      # def ingestion
      #   Ingestion
      # end

      def initialization
        @initialization ||= Initialization.middleware
      end
    end
  end
end
