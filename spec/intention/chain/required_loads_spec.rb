# frozen_string_literal: true

require 'support/shared'

module Intention
  RSpec.describe '::required chained with ::loads', type: :chain do
    attribute_name = Support::Shared.random_attribute_name
    let(:callable) { proc {} }

    let(:klass) do
      local_callable = callable

      Class.new do
        include Intention

        required(attribute_name).loads(&local_callable)
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

      it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }

      context 'when not given a callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          Class.new do
            include Intention

            required(attribute_name).loads
          end
        end

        it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }
      end
    end
  end
end
