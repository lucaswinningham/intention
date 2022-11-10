# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.describe Intention::Attribution do
  include Support::Matchers::HaveMethod

  let(:klass) do
    Class.new do
      include Intention::Attribution
    end
  end

  it 'defines ::attribute' do
    expect(klass).to have_method :attribute
  end

  describe '::attribute' do
    it 'is private' do
      expect { klass.attribute }.to raise_error(NoMethodError)
    end

    it 'requires `name` argument' do
      expect { klass.__send__(:attribute) }.to raise_error(ArgumentError)
    end

    it 'initializes a new Attribute with the underlying class and the attribute name' do
      name = :some_name

      expect(Intention::Attribution::Attribute).to receive(:new).with(class: klass, name: name)

      klass.__send__(:attribute, name)
    end

    describe 'instance effects' do
      let(:attribute_name) { :some_attribute }
      let(:attribute_value) { :some_attribute_value }

      let(:instance) { klass.new }

      before { klass.__send__(:attribute, attribute_name) }

      it 'defines a getter' do
        expect(instance.respond_to?(attribute_name)).to be true
      end

      it 'getter gets value' do
        instance.__send__("#{attribute_name}=", attribute_value)

        expect(instance.__send__(attribute_name)).to be attribute_value
      end

      it 'defines a setter' do
        expect(instance.respond_to?("#{attribute_name}=")).to be true
      end

      it 'setter sets value' do
        other_attribute_value = :some_other_attribute_value
        instance.__send__("#{attribute_name}=", other_attribute_value)

        expect(instance.__send__(attribute_name)).to be other_attribute_value
      end
    end
  end
end
