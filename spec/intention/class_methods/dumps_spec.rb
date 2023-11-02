require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::dumps', type: :class_method do
  include Support::Matchers::HaveMethod

  before { klass.__send__(:serializable) }

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :dumps }
  it('is private') { expect(klass).not_to respond_to :dumps }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:dumps, :dumps_atr)

    expect(klass).to have_received(:attribute).with(:dumps_atr)
  end

  describe '#to_h' do
    subject(:hash) { instance.to_h }

    before do
      allow(callable).to receive(:call).and_return(:callable_result)

      klass.__send__(:dumps, :dumps_to_h_atr, &callable)
    end

    let(:instance) { klass.new(dumps_to_h_atr: :dumps_to_h_val) }
    let(:callable) { proc {} }

    it 'calls the callable with the value and the instance' do
      hash

      expect(callable).to have_received(:call).with(:dumps_to_h_val, instance)
    end

    it 'serializes the callable result' do
      expect(hash[:dumps_to_h_atr]).to be :callable_result
    end
  end
end
