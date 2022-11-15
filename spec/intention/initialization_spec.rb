# frozen_string_literal: true

require 'ostruct'

RSpec.describe Intention::Initialization do
  let(:klass) do
    Class.new do
      include Intention::Initialization
      include Intention::Attribution
    end
  end

  describe '#initialize' do
    let(:attribute_name) { :some_attribute }
    let(:attribute_value) { :some_attribute_value }
    let(:input_hash) { { attribute_name => attribute_value } }

    let(:instance) { klass.new(input_hash) }

    before { klass.__send__(:attribute, attribute_name) }

    describe '#input_hash' do
      it 'is private' do
        expect(instance).not_to respond_to :input_hash
      end

      it 'is set to the input hash' do
        expect(instance.__send__(:input_hash)).to be input_hash
      end

      # it 'method name is configurable' do
      #   name_before = Intention.config.instance_input_hash_name
      #   custom_input_hash_method_name = :custom_input_hash_method_name
      #   Intention.config.instance_input_hash_name = custom_input_hash_method_name

      #   expect(instance.__send__(custom_input_hash_method_name)).to be input_hash

      #   Intention.config.instance_input_hash_name = name_before
      # end
    end
  end
end
