# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '::attribute chained with ::loads', type: :chain do
    let(:attribute_name) { Support::Shared.random_attribute_name }
    let(:callable) { proc {} }

    let(:klass) do
      local_attribute_name = attribute_name
      local_callable = callable

      Class.new do
        include Intention

        attribute(local_attribute_name).loads(&local_callable)
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

      it 'calls callable with value and the instance' do
        allow(callable).to receive(:call)

        instance

        expect(callable).to have_received(:call).with(value, instance)
      end

      it 'saves callable result' do
        value = Support::Shared.empty_natives.sample

        allow(callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('is does not raise error') { expect { instance }.not_to raise_error }

      it 'calls callable with nil and the instance' do
        allow(callable).to receive(:call)

        instance

        expect(callable).to have_received(:call).with(nil, instance)
      end

      it 'saves callable result' do
        value = Support::Shared.empty_natives.sample

        allow(callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end

      context 'when not given a callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name

          Class.new do
            include Intention

            attribute(local_attribute_name).loads
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }
        it('defaults to nil') { expect(instance.__send__(attribute_name)).to be_nil }
      end
    end
  end
end
