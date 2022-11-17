# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/instance_accessors'

RSpec.describe 'Intention::attribute', type: :feature do
  attribute_name = Support::Shared.random_attribute_name

  context "when called with #{attribute_name.inspect}" do
    let(:klass) do
      Class.new do
        include Intention

        attribute attribute_name
      end
    end

    include_examples 'instance_accessors', name: attribute_name do
      subject(:instance) { klass.new }
    end

    Support::Shared.natives.each do |value|
      context "when #initialization given #{value.inspect} for #{attribute_name.inspect}" do
        subject(:instance) { klass.new attribute_name => value }

        it "saves #{value.inspect} to #{attribute_name.inspect}" do
          expect(instance.instance_variable_get(:"@#{attribute_name}")).to be value
        end
      end
    end

    context "when #initialization not given an entry for #{attribute_name.inspect}" do
      subject(:instance) { klass.new }

      it "saves nil to #{attribute_name.inspect}" do
        expect(instance.instance_variable_get(:"@#{attribute_name}")).to be_nil
      end
    end
  end
end
