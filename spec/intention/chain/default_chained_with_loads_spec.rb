# frozen_string_literal: true

RSpec.describe '::default chained with ::loads', type: :chain do
  let(:default_callable) { proc {} }
  let(:loads_callable) { proc {} }

  let(:klass) do
    local_default_callable = default_callable
    local_loads_callable = loads_callable

    Class.new do
      include Intention

      default(:default_chained_with_loads_atr, &local_default_callable).loads(&local_loads_callable)
    end
  end

  describe '#initialize' do
    context 'when not given a value for the attribute' do
      before do
        allow(default_callable).to receive(:call) { :default_callable_result }
        allow(loads_callable).to receive(:call) { :loads_callable_result }
      end

      subject(:instance) { klass.new }

      it 'calls the default callable with the instance' do
        instance

        expect(default_callable).to have_received(:call).with instance
      end

      it 'calls the loads callable with the default callable result and the instance' do
        instance

        expect(loads_callable).to have_received(:call).with(:default_callable_result, instance)
      end

      it 'saves the loads callable result' do
        expect(instance.default_chained_with_loads_atr).to be :loads_callable_result
      end
    end
  end
end
