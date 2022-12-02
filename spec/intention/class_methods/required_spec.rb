# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::required', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :required }
  it('is private') { expect(klass).not_to respond_to :required }

  it('calls ::attribute with the attribute name') do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:required, :req_atr)

    expect(klass).to have_received(:attribute).with(:req_atr)
  end

  context 'when called without a custom error class' do
    before { klass.__send__(:required, :req_init_atr_no_custom) }

    describe '#initialize' do
      context 'when not given a value for the attribute' do
        subject(:instance) { klass.new }

        it('raises error') { expect { instance }.to raise_error(Intention::RequiredAttributeError) }
      end
    end
  end

  context 'when called with a custom error class' do
    before do
      stub_const('CustomErrorClass', Class.new(StandardError))
      klass.__send__(:required, :req_init_atr_custom, CustomErrorClass)
    end

    describe '#initialize' do
      context 'when not given a value for the attribute' do
        subject(:instance) { klass.new }

        it('raises the custom error class') { expect { instance }.to raise_error(CustomErrorClass) }
      end
    end
  end
end
