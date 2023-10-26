# frozen_string_literal: true

module Intention
  class Link # rubocop:disable Style/Documentation
    class KlassRequiredError < StandardError; end

    def initialize(options = {})
      @klass = options.fetch(:klass) { raise KlassRequiredError }
    end

    def attribute_initialization
      @attribute_initialization ||= Middleware::Builder.new do
        use(Intention.configuration.attribute_initialization)
      end
    end

    # def ingestion
    #   @ingestion ||= Middleware::Builder.new do
    #     use(AddToPayload, intention: self, klass: klass)
    #     use(Intention.configuration.ingestion)
    #   end
    # end

    def initialization
      @initialization ||= Middleware::Builder.new do
        use(Intention.configuration.initialization)
      end
    end

    def attributes
      @attributes ||= Hash.new do |h, name|
        h[name] = Intention::Attribute::Instance.new(intention: self, klass: klass, name: name)
      end
    end

    private

    attr_reader :klass
  end
end
