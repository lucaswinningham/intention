require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::field', type: :class_method do
  include Support::Matchers::HaveMethod

  before { klass.__send__(:serializable) }

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :field }
  it('is private') { expect(klass).not_to respond_to :field }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:field, :field_atr)

    expect(klass).to have_received(:attribute).with(:field_atr)
  end

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:field, :field_atr) }

    it('the getter method is private') { expect(instance).not_to respond_to :field_atr }
    it('the setter method is private') { expect(instance).not_to respond_to :field_atr= }
  end

  describe '#to_h' do
    subject(:hash) { klass.new(field_to_h_atr: :field_to_h_atr_val).to_h }

    before { klass.__send__(:field, :field_to_h_atr) }

    it('does not serialize the attribute') { expect(hash.key?(:field_to_h_atr)).to be false }
  end

  describe '#initialize' do
    before do
      allow(callable).to receive(:call).and_return(:callable_result)

      klass.__send__(:field, :field_init_atr, &callable)
    end

    let(:callable) { proc {} }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new field_init_atr: :field_init_val }

      it 'does not call the callable' do
        instance

        expect(callable).not_to have_received(:call)
      end
    end

    context 'when given nil for the attribute' do
      subject(:instance) { klass.new field_init_atr: nil }

      it 'does not call the callable' do
        instance

        expect(callable).not_to have_received(:call)
      end
    end

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it 'calls the callable with the instance' do
        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves the callable result' do
        expect(instance.__send__(:field_init_atr)).to be :callable_result
      end
    end
  end
end
