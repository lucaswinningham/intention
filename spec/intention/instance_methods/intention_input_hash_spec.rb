# frozen_string_literal: true

require 'support/matchers/have_method'

module Intention
  RSpec.describe '#intention_input_hash', type: :instance_method do
    let(:klass) do
      Class.new do
        include Intention
      end
    end

    describe 'getter' do
      include Support::Matchers::HaveMethod

      subject(:instance) { klass.new }

      it('is defined') { expect(subject).to have_method :intention_input_hash }
      it('is private') { expect(subject).not_to respond_to :intention_input_hash }
    end

    describe 'setter' do
      include Support::Matchers::HaveMethod

      subject(:instance) { klass.new }

      it('is not defined') { expect(instance).not_to have_method :intention_input_hash= }
    end

    context 'when #initialize is given entries' do
      subject(:instance) { klass.new input_hash }

      let(:input_hash) do
        {
          this_attribute: :this_value,
          that_attribute: :that_value,
          the_other_attribute: :the_other_value
        }
      end

      it 'saves the entries to #intention_input_hash' do
        expect(instance.__send__(:intention_input_hash)).to be input_hash
      end
    end

    it 'method name is configurable'
  end
end
