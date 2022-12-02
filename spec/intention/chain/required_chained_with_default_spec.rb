# frozen_string_literal: true

RSpec.describe '::required chained with ::default', type: :chain do
  let(:callable) { proc {} }

  let(:klass) do
    local_callable = callable

    Class.new do
      include Intention

      required(:required_chained_with_default_atr).default(&local_callable)
    end
  end

  describe '#initialize' do
    context 'when not given a value for the attribute' do
      before { allow(callable).to receive(:call) { :callable_result } }

      subject(:instance) { klass.new }

      it 'calls the callable with the instance' do
        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves the callable result' do
        expect(instance.required_chained_with_default_atr).to be :callable_result
      end
    end
  end
end
