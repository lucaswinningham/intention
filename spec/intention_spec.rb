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
    random_name = RandomAlphabeticalString.generate

    context "when called with :#{random_name}" do
      klass = Class.new do
        include Intention
        attribute random_name
      end

      include_examples 'accessors', name: random_name do
        subject { klass.new }
      end

      describe '::new effects' do
        context "when given an input value for :#{random_name}" do
          value = RandomAlphabeticalString.generate
          subject(:instance) { klass.new random_name => value }

          it "saves input value as instance variable :@#{random_name}" do
            expect(instance.instance_variable_get(:"@#{random_name}")).to be value
          end
        end

        context "when not given an input value for :#{random_name}" do
          subject(:instance) { klass.new }

          it 'does not save input value' do
            expect(instance.instance_variable_get(:"@#{random_name}")).to be_nil
          end
        end
      end
    end
  end

  describe '::required' do
    random_name = RandomAlphabeticalString.generate
    class RequiredError < StandardError; end

    context "when called with :#{random_name} and #{RequiredError}" do
      klass = Class.new do
        include Intention
        required random_name, RequiredError
      end

      include_examples 'accessors', name: random_name do
        subject { klass.new random_name => RandomAlphabeticalString.generate }
      end

      describe '::new effects' do
        context "when given an input value for :#{random_name}" do
          value = RandomAlphabeticalString.generate
          subject(:instance) { klass.new random_name => value }

          it "saves input value as instance variable :@#{random_name}" do
            expect(instance.instance_variable_get(:"@#{random_name}")).to be value
          end
        end

        context "when not given an input value for :#{random_name}" do
          subject(:instance) { klass.new }

          it "raises #{RequiredError}" do
            expect { instance }.to raise_error(RequiredError)
          end
        end
      end
    end
  end
end
