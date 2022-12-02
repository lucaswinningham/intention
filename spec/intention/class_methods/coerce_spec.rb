# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::coerce', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :coerce }
  it('is private') { expect(klass).not_to respond_to :coerce }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:coerce, :coerce_atr)

    expect(klass).to have_received(:attribute).with(:coerce_atr)
  end

  describe '#initialize' do
    before do
      allow(callable).to receive(:call) { :callable_result }

      klass.__send__(:coerce, :coerce_init_atr, &callable)
    end

    let(:callable) { proc {} }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new coerce_init_atr: :coerce_init_val }

      it 'does not call the callable' do
        instance

        expect(callable).not_to have_received(:call)
      end
    end

    context 'when given nil for the attribute' do
      subject(:instance) { klass.new coerce_init_atr: nil }

      it 'calls the callable with the instance' do
        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves the callable result' do
        expect(instance.coerce_init_atr).to be :callable_result
      end
    end

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it 'calls the callable with the instance' do
        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves the callable result' do
        expect(instance.coerce_init_atr).to be :callable_result
      end
    end
  end
end
