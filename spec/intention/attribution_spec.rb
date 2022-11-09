# frozen_string_literal: true

RSpec.describe Intention::Attribution do
  let(:klass) do
    Class.new do
      include Intention::Attribution
    end
  end

  let(:accessible_klass) do
    klass.tap do
      klass.send(:public_class_method, :attribute)
    end
  end

  it 'is private' do
    expect { klass.attribute }.to raise_error(NoMethodError)
  end

  it 'requires `name` argument' do
    expect { accessible_klass.attribute }.to raise_error(ArgumentError)
  end

  describe 'instance' do
    let(:attribute_name) { :some_attribute }
    let(:attribute_value) { :some_attribute_value }

    let(:instance) { accessible_klass.new }

    before { accessible_klass.attribute(attribute_name) }

    describe 'getter' do
      it 'is defined' do
        expect(instance.respond_to?(attribute_name)).to be true
      end

      it 'retrieves value' do
        instance.public_send("#{attribute_name}=", attribute_value)

        expect(instance.public_send(attribute_name)).to be attribute_value
      end
    end

    describe 'setter' do
      it 'is defined' do
        expect(instance.respond_to?("#{attribute_name}=")).to be true
      end

      it 'sets value' do
        other_attribute_value = :some_other_attribute_value
        instance.public_send("#{attribute_name}=", other_attribute_value)

        expect(instance.public_send(attribute_name)).to be other_attribute_value
      end
    end
  end
end
