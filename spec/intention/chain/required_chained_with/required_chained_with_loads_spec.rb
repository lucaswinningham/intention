# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '::required chained with ::loads', type: :chain do
    let(:attribute_name) { Support::Shared.random_attribute_name }
    let(:loads_callable) { proc {} }

    let(:klass) do
      local_attribute_name = attribute_name
      local_loads_callable = loads_callable

      Class.new do
        include Intention

        required(local_attribute_name).loads(&local_loads_callable)
      end
    end

    describe 'instance attribute accessor' do
      include_examples 'accessor' do
        subject { klass.new attribute_name => nil }

        let(:accessor_name) { attribute_name }
      end
    end

    context 'when #initialize is given a value' do
      subject(:instance) { klass.new attribute_name => value }

      let(:value) { Support::Shared.empty_natives.sample }

      it('is does not raise error') { expect { instance }.not_to raise_error }

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

      it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }

      context 'when not given a loads callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name

          Class.new do
            include Intention

            required(local_attribute_name).loads
          end
        end

        it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }
      end
    end
  end
end
