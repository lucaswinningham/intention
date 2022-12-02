# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::default', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :default }
  it('is private') { expect(klass).not_to respond_to :default }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:default, :default_atr)

    expect(klass).to have_received(:attribute).with(:default_atr)
  end

  describe '#initialize' do
    before do
      allow(callable).to receive(:call).and_return(:callable_result)

      klass.__send__(:default, :default_init_atr, &callable)
    end

    let(:callable) { proc {} }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new default_init_atr: :default_init_val }

      it 'does not call the callable' do
        instance

        expect(callable).not_to have_received(:call)
      end
    end

    context 'when given nil for the attribute' do
      subject(:instance) { klass.new default_init_atr: nil }

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
        expect(instance.default_init_atr).to be :callable_result
      end
    end
  end
end
