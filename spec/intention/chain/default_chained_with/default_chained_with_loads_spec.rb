# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '::default chained with ::loads', type: :chain do
    let(:attribute_name) { Support::Shared.random_attribute_name }
    let(:default_callable) { proc {} }
    let(:loads_callable) { proc {} }

    let(:klass) do
      local_attribute_name = attribute_name
      local_default_callable = default_callable
      local_loads_callable = loads_callable

      Class.new do
        include Intention

        default(local_attribute_name, &local_default_callable).loads(&local_loads_callable)
      end
    end

    describe 'instance attribute accessor' do
      include_examples 'accessor' do
        subject { klass.new }

        let(:accessor_name) { attribute_name }
      end
    end

    context 'when #initialize is given a value' do
      subject(:instance) { klass.new attribute_name => value }

      let(:value) { Support::Shared.empty_natives.sample }

      it('is does not raise error') { expect { instance }.not_to raise_error }

      it 'does not call default callable' do
        allow(default_callable).to receive(:call)

        instance

        expect(default_callable).not_to have_received(:call)
      end

      it 'calls loads callable with value and the instance' do
        allow(loads_callable).to receive(:call)

        instance

        expect(loads_callable).to have_received(:call).with(value, instance)
      end

      it 'saves loads callable result' do
        value = Support::Shared.empty_natives.sample

        allow(loads_callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('is does not raise error') { expect { instance }.not_to raise_error }

      it 'calls default callable with the instance' do
        allow(default_callable).to receive(:call)

        instance

        expect(default_callable).to have_received(:call).with instance
      end

      it 'calls loads callable with default callable result and the instance' do
        value = Support::Shared.random_string

        allow(default_callable).to receive(:call) { value }
        allow(loads_callable).to receive(:call)

        instance

        expect(loads_callable).to have_received(:call).with(value, instance)
      end

      it 'saves loads callable result' do
        value = Support::Shared.random_string

        allow(loads_callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end

      context 'when not given a default callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name
          local_loads_callable = loads_callable

          Class.new do
            include Intention

            default(local_attribute_name).loads(&local_loads_callable)
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }

        it 'calls loads callable with nil and the instance' do
          allow(loads_callable).to receive(:call)

          instance

          expect(loads_callable).to have_received(:call).with(nil, instance)
        end

        it 'saves loads callable result' do
          value = Support::Shared.empty_natives.sample

          allow(loads_callable).to receive(:call) { value }

          expect(instance.__send__(attribute_name)).to be value
        end
      end

      context 'when not given a loads callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name
          local_default_callable = default_callable

          Class.new do
            include Intention

            default(local_attribute_name, &local_default_callable).loads
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }

        it 'calls default callable with the instance' do
          allow(default_callable).to receive(:call)

          instance

          expect(default_callable).to have_received(:call).with instance
        end

        it 'saves default callable result' do
          value = Support::Shared.random_string

          allow(default_callable).to receive(:call) { value }

          expect(instance.__send__(attribute_name)).to be value
        end
      end

      context 'when not given a default callable and not given a loads callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name

          Class.new do
            include Intention

            default(local_attribute_name).loads
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }
        it('defaults to nil') { expect(instance.__send__(attribute_name)).to be_nil }
      end
    end
  end
end
