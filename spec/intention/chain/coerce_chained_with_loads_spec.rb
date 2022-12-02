# frozen_string_literal: true

RSpec.describe '::coerce chained with ::loads', type: :chain do
  let(:coerce_callable) { proc {} }
  let(:loads_callable) { proc {} }

  let(:klass) do
    local_coerce_callable = coerce_callable
    local_loads_callable = loads_callable

    Class.new do
      include Intention

      coerce(:coerce_chained_with_loads_atr, &local_coerce_callable).loads(&local_loads_callable)
    end
  end

  describe '#initialize' do
    before do
      allow(coerce_callable).to receive(:call).and_return(:coerce_callable_result)
      allow(loads_callable).to receive(:call).and_return(:loads_callable_result)
    end

    context 'when given nil for the attribute' do
      subject(:instance) { klass.new coerce_chained_with_loads_atr: nil }

      it 'calls the coerce callable with the instance' do
        instance

        expect(coerce_callable).to have_received(:call).with instance
      end

      it 'calls the loads callable with the coerce callable result and the instance' do
        instance

        expect(loads_callable).to have_received(:call).with(:coerce_callable_result, instance)
      end

      it 'saves the loads callable result' do
        expect(instance.coerce_chained_with_loads_atr).to be :loads_callable_result
      end
    end

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      before do
        allow(coerce_callable).to receive(:call).and_return(:coerce_callable_result)
        allow(loads_callable).to receive(:call).and_return(:loads_callable_result)
      end

      it 'calls the coerce callable with the instance' do
        instance

        expect(coerce_callable).to have_received(:call).with instance
      end

      it 'calls the loads callable with the coerce callable result and the instance' do
        instance

        expect(loads_callable).to have_received(:call).with(:coerce_callable_result, instance)
      end

      it 'saves the loads callable result' do
        expect(instance.coerce_chained_with_loads_atr).to be :loads_callable_result
      end
    end
  end
end
