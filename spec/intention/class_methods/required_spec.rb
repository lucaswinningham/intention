# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::required', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :required }
  it('is private') { expect(klass).not_to respond_to :required }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:required, :required_atr)

    expect(klass).to have_received(:attribute).with(:required_atr)
  end

  describe '#initialize' do
    before { klass.__send__(:required, :required_init_atr) }

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it 'raises an error' do
        expect { instance }.to raise_error(Intention::RequiredAttributeError)
      end
    end
  end

  context 'when called with a custom error class' do
    before do
      stub_const('CustomErrorClass', Class.new(StandardError))
      klass.__send__(:required, :required_init_atr_custom_error_class, CustomErrorClass)
    end

    describe '#initialize' do
      context 'when not given a value for the attribute' do
        subject(:instance) { klass.new }

        it 'raises the custom error class' do
          expect { instance }.to raise_error(CustomErrorClass)
        end
      end
    end
  end

  context 'when called with a callable' do
    before do
      klass.__send__(:required, :required_init_atr_custom_error_class, &callable)
    end

    let(:callable) { proc {} }

    describe '#initialize' do
      context 'when not given a value for the attribute' do
        subject(:instance) { klass.new }

        it 'calls the callable with the instance' do
          allow(callable).to receive(:call)

          instance

          expect(callable).to have_received(:call).with instance
        end

        context 'when callable evaluates to truthy' do
          before { allow(callable).to receive(:call).and_return(:yes) }

          it 'raises an error' do
            expect { instance }.to raise_error(Intention::RequiredAttributeError)
          end
        end

        [nil, false].each do |falsey|
          context "when callable evaluates to #{falsey.inspect}" do
            before { allow(callable).to receive(:call) { falsey } }

            it('does not raise an error') { expect { instance }.not_to raise_error }
          end
        end
      end
    end
  end
end
