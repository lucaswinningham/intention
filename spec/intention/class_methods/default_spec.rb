# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::default', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :default }
  it('is private') { expect(klass).not_to respond_to :default }

  it('calls ::attribute with the attribute name') do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:default, :def_atr)

    expect(klass).to have_received(:attribute).with(:def_atr)
  end

  describe '#initialize' do
    before { klass.__send__(:default, :def_init_atr, &callable) }

    let(:callable) { proc {} }

    context 'when not given a value for the attribute' do
      before { allow(callable).to receive(:call) { :callable_result } }

      subject(:instance) { klass.new }

      it 'calls the callable with the instance' do
        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves the callable result' do
        expect(instance.def_init_atr).to be :callable_result
      end
    end
  end
end
