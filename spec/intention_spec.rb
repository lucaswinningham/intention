# frozen_string_literal: true

require 'intention/shared/accessors'

module RandomAlphabeticalString
  class << self
    def generate(options = {})
      length = options.fetch(:length, 8)

      Array.new(length) { [*('a'..'z'), *('A'..'Z')].sample }.join
    end
  end
end

RSpec.describe Intention do
  it 'has a version number' do
    expect(Intention::VERSION).not_to be_nil
  end

  describe '#intention_input_hash' do
    klass = Class.new do
      include Intention
    end

    input_hash = { some_attribute: :some_attribute_value }

    include_examples(
      'accessors',
      name: :intention_input_hash,
      getter: { level: :private },
      setter: { defined: false }
    ) do
      subject(:instance) { klass.new(input_hash) }

      it 'is set to the input hash' do
        expect(instance.__send__(:intention_input_hash)).to be input_hash
      end
    end

    # it 'method name is configurable' do
    #   name_before = Intention.config.instance_input_hash_name
    #   custom_input_hash_method_name = :custom_input_hash_method_name
    #   Intention.config.instance_input_hash_name = custom_input_hash_method_name

    #   expect(instance.__send__(custom_input_hash_method_name)).to be input_hash

    #   Intention.config.instance_input_hash_name = name_before
    # end
  end

  describe '::attribute' do
    attribute_name = RandomAlphabeticalString.generate

    context "when called with :#{attribute_name}" do
      klass = Class.new do
        include Intention
        attribute attribute_name
      end

      include_examples 'accessors', name: attribute_name do
        subject { klass.new }
      end

      describe 'instance' do
        [nil, false, 'some_string', :some_symbol, 1, [], {}].each do |value|
          context "when given #{value.inspect} for :#{attribute_name}" do
            subject(:instance) { klass.new attribute_name => value }

            it "saves #{value.inspect} to :@#{attribute_name}" do
              expect(instance.instance_variable_get(:"@#{attribute_name}")).to be value
            end
          end
        end

        context "when not given an input value for :#{attribute_name}" do
          subject(:instance) { klass.new }

          it "saves nil to :@#{attribute_name}" do
            expect(instance.instance_variable_get(:"@#{attribute_name}")).to be_nil
          end
        end
      end
    end
  end

  describe '::required' do
    attribute_name = RandomAlphabeticalString.generate

    context "when called with :#{attribute_name} and an error class" do
      required_error_class = Class.new(StandardError)

      klass = Class.new do
        include Intention
        required attribute_name, required_error_class
      end

      include_examples 'accessors', name: attribute_name do
        subject { klass.new attribute_name => nil }
      end

      describe 'instance' do
        [nil, false, 'some_string', :some_symbol, 1, [], {}].each do |value|
          context "when given #{value.inspect} for :#{attribute_name}" do
            subject(:instance) { klass.new attribute_name => value }

            it "saves #{value.inspect} to :@#{attribute_name}" do
              expect(instance.instance_variable_get(:"@#{attribute_name}")).to be value
            end
          end
        end

        context "when not given a value for :#{attribute_name}" do
          subject(:instance) { klass.new }

          it 'raises error class' do
            expect { instance }.to raise_error(required_error_class)
          end
        end
      end
    end
  end
end
