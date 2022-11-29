# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '::attribute', type: :class_method do
    let(:attribute_name) { Support::Shared.random_attribute_name }

    let(:klass) do
      local_attribute_name = attribute_name

      Class.new do
        include Intention

        attribute local_attribute_name
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

      it('does not raise error') { expect { instance }.not_to raise_error }
      it('saves value') { expect(instance.__send__(attribute_name)).to be value }
    end

    context 'when #initialize is not given a value' do
      subject(:instance) { klass.new }

      it('does not raise error') { expect { instance }.not_to raise_error }
      it('defaults to nil') { expect(instance.__send__(attribute_name)).to be_nil }
    end
  end
end
