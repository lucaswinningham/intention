# frozen_string_literal: true

RSpec.describe '::null chained with ::loads', type: :chain do
  let(:null_callable) { proc {} }
  let(:loads_callable) { proc {} }

  let(:klass) do
    local_null_callable = null_callable
    local_loads_callable = loads_callable

    Class.new do
      include Intention

      null(:null_chained_with_loads_atr, &local_null_callable).loads(&local_loads_callable)
    end
  end

  describe '#initialize' do
    before do
      allow(null_callable).to receive(:call).and_return(:null_callable_result)
      allow(loads_callable).to receive(:call).and_return(:loads_callable_result)
    end

    context 'when given nil for the attribute' do
      subject(:instance) { klass.new null_chained_with_loads_atr: nil }

      it 'calls the null callable with the instance' do
        instance

        expect(null_callable).to have_received(:call).with instance
      end

      it 'calls the loads callable with the null callable result and the instance' do
        instance

        expect(loads_callable).to have_received(:call).with(:null_callable_result, instance)
      end

      it 'saves the loads callable result' do
        expect(instance.null_chained_with_loads_atr).to be :loads_callable_result
      end
    end
  end
end
