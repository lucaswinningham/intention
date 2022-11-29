# frozen_string_literal: true

require 'support/shared'

module Intention
  RSpec.describe '::attribute chained with ::default', type: :chain do
    attribute_name = Support::Shared.random_attribute_name
    let(:callable) { proc {} }

    let(:klass) do
      local_callable = callable

      Class.new do
        include Intention

        attribute(attribute_name).default(&local_callable)
      end
    end

    context 'when #initialize is given a value' do
      subject(:instance) { klass.new attribute_name => value }

      let(:value) { Support::Shared.empty_natives.sample }

      it('is does not raise error') { expect { instance }.not_to raise_error }
      it('saves value') { expect(instance.__send__(attribute_name)).to be value }
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('is does not raise error') { expect { instance }.not_to raise_error }

      it 'calls callable with value' do
        allow(callable).to receive(:call)

        instance

        expect(callable).to have_received(:call).with instance
      end

      it 'saves callable result' do
        value = Support::Shared.empty_natives.sample

        allow(callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end

      context 'when not given a callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          Class.new do
            include Intention

            attribute(attribute_name).default
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }
        it('defaults to nil') { expect(instance.__send__(attribute_name)).to be_nil }
      end
    end
  end
end
