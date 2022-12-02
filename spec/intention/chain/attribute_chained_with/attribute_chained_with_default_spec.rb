# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '::attribute chained with ::default', type: :chain do
    let(:attribute_name) { Support::Shared.random_attribute_name }
    let(:default_callable) { proc {} }

    let(:klass) do
      local_attribute_name = attribute_name
      local_default_callable = default_callable

      Class.new do
        include Intention

        attribute(local_attribute_name).default(&local_default_callable)
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
      it('saves value') { expect(instance.__send__(attribute_name)).to be value }

      it 'does not call default callable' do
        allow(default_callable).to receive(:call)

        instance

        expect(default_callable).not_to have_received(:call)
      end
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('is does not raise error') { expect { instance }.not_to raise_error }

      it 'calls default callable with value' do
        allow(default_callable).to receive(:call)

        instance

        expect(default_callable).to have_received(:call).with instance
      end

      it 'saves default callable result' do
        value = Support::Shared.random_string

        allow(default_callable).to receive(:call) { value }

        expect(instance.__send__(attribute_name)).to be value
      end

      context 'when not given a default callable' do
        subject(:instance) { klass.new }

        let(:klass) do
          local_attribute_name = attribute_name

          Class.new do
            include Intention

            attribute(local_attribute_name).default
          end
        end

        it('is does not raise error') { expect { instance }.not_to raise_error }
        it('defaults to nil') { expect(instance.__send__(attribute_name)).to be_nil }
      end
    end
  end
end
