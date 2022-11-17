# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/instance_accessors'

RSpec.describe 'Intention#intention_input_hash', type: :feature do
  klass = Class.new do
    include Intention
  end

  input_hash = { Support::Shared.random_attribute_name => Support::Shared.random_string }

  include_examples(
    'instance_accessors',
    name: :intention_input_hash,
    getter: { level: :private },
    setter: { defined: false }
  ) do
    subject(:instance) { klass.new(input_hash) }
  end

  context 'when #initialization given entries' do
    subject(:instance) { klass.new input_hash }

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
