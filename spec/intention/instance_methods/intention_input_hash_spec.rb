# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/accessor'

module Intention
  RSpec.describe '#intention_input_hash', type: :instance_method do
    let(:klass) do
      Class.new do
        include Intention
      end
    end

    describe 'instance #intention_input_hash accessor' do
      include_examples 'accessor', getter: { level: :private }, setter: { defined: false } do
        subject { klass.new }

        let(:accessor_name) { :intention_input_hash }
      end
    end

    context 'when #initialize is given entries' do
      subject(:instance) { klass.new input_hash }

      let(:input_hash) do
        { Support::Shared.random_attribute_name => Support::Shared.random_string }
      end

      it 'saves entries to #intention_input_hash' do
        expect(instance.__send__(:intention_input_hash)).to be input_hash
      end
    end

    # it 'method name is configurable' do
    #   name_before = Intention.config.instance_input_hash_name
    #   custom_input_hash_method_name = :custom_input_hash_method_name
    #   Intention.config.instance_input_hash_name = custom_input_hash_method_name

    #   expect(instance.__send__(custom_input_hash_method_name)).to be input_hash

    #   Intention.config.instance_input_hash_name = name_before
    # end
  end
end
