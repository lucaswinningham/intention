# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::loads', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :loads }
  it('is private') { expect(klass).not_to respond_to :loads }

  it('calls ::attribute with the attribute name') do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:loads, :loads_atr)

    expect(klass).to have_received(:attribute).with(:loads_atr)
  end

  describe 'instance accessor' do
    before { klass.__send__(:loads, :loads_acs_atr, &callable) }

    let(:callable) { proc {} }

    subject(:instance) { klass.new }

    context 'when setter method is called' do
      before do
        allow(callable).to receive(:call) { :setter_result }

        subject.loads_acs_atr = :loads_acs_val
      end

      it 'calls the callable with the value and the instance' do
        expect(callable).to have_received(:call).with(:loads_acs_val, instance)
      end

      it 'saves the callable result' do
        expect(instance.loads_acs_atr).to be :setter_result
      end
    end
  end

  describe '#initialize' do
    before { klass.__send__(:loads, :loads_init_atr, &callable) }

    let(:callable) { proc {} }

    context 'when given a value for the attribute' do
      before { allow(callable).to receive(:call) { :processed_result } }

      subject(:instance) { klass.new loads_init_atr: :loads_init_val }

      it 'calls the callable with the value and the instance' do
        instance

        expect(callable).to have_received(:call).with(:loads_init_val, instance)
      end

      it 'saves the callable result' do
        expect(instance.loads_init_atr).to be :processed_result
      end
    end

    context 'when not given a value for the attribute' do
      before { allow(callable).to receive(:call) { :callable_result } }

      subject(:instance) { klass.new }

      it 'calls the callable with nil and the instance' do
        instance

        expect(callable).to have_received(:call).with(nil, instance)
      end

      it 'saves the callable result' do
        expect(instance.loads_init_atr).to be :callable_result
      end
    end
  end
end
