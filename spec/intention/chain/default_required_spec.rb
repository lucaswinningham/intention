# frozen_string_literal: true

require 'support/shared'

module Intention
  RSpec.describe '::default chained with ::required', type: :chain do
    attribute_name = Support::Shared.random_attribute_name

    let(:klass) do
      Class.new do
        include Intention

        default(attribute_name).required
      end
    end

    context 'when #initialize is given a value' do
      subject(:instance) { klass.new attribute_name => value }

      let(:value) { Support::Shared.empty_natives.sample }

      it('does not raise error') { expect { instance }.not_to raise_error }
      it('saves value') { expect(instance.__send__(attribute_name)).to be value }
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }

      context 'when given a custom error class' do
        before do
          stub_const('RequiredError', Class.new(StandardError))
        end

        let(:klass) do
          Class.new do
            include Intention

            required(attribute_name, RequiredError)
          end
        end

        it('raises custom error') { expect { instance }.to raise_error(RequiredError) }
      end
    end
  end
end
