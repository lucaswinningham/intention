# frozen_string_literal: true

require 'support/shared'
require 'support/shared/examples/instance_accessors'

RSpec.describe 'Intention::required', type: :feature do
  attribute_name = Support::Shared.random_attribute_name

  context "when called with #{attribute_name.inspect}" do
    context 'without a custom error class' do
      let(:klass) do
        Class.new do
          include Intention

          required attribute_name
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises a generic error' do
          expect { instance }.to raise_error(Intention::RequiredAttributeError)
        end
      end
    end

    context 'with a custom error class' do
      before do
        stub_const('RequiredError', Class.new(StandardError))
      end

      let(:klass) do
        Class.new do
          include Intention

          required(attribute_name, RequiredError)
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises the custom error' do
          expect { instance }.to raise_error(RequiredError)
        end
      end
    end
  end

  context "when chained with ::attribute(#{attribute_name.inspect})" do
    context 'without a custom error class' do
      let(:klass) do
        Class.new do
          include Intention

          attribute(attribute_name).required
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises a generic error' do
          expect { instance }.to raise_error(Intention::RequiredAttributeError)
        end
      end
    end

    context 'with a custom error class' do
      before do
        stub_const('RequiredError', Class.new(StandardError))
      end

      let(:klass) do
        Class.new do
          include Intention

          attribute(attribute_name).required RequiredError
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises the custom error' do
          expect { instance }.to raise_error(RequiredError)
        end
      end
    end
  end

  context "when chained with ::default(#{attribute_name.inspect})" do
    context 'without a custom error class' do
      let(:klass) do
        Class.new do
          include Intention

          default(attribute_name).required
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises a generic error' do
          expect { instance }.to raise_error(Intention::RequiredAttributeError)
        end
      end
    end

    context 'with a custom error class' do
      before do
        stub_const('RequiredError', Class.new(StandardError))
      end

      let(:klass) do
        Class.new do
          include Intention

          default(attribute_name).required RequiredError
        end
      end

      include_examples 'instance_accessors', name: attribute_name do
        subject(:instance) { klass.new attribute_name => nil }
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

        it 'raises the custom error' do
          expect { instance }.to raise_error(RequiredError)
        end
      end
    end
  end
end
