require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::hidden', type: :class_method do
  include Support::Matchers::HaveMethod

  before { klass.__send__(:serializable) }

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :hidden }
  it('is private') { expect(klass).not_to respond_to :hidden }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:hidden, :hidden_atr)

    expect(klass).to have_received(:attribute).with(:hidden_atr)
  end

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:hidden, :hidden_atr) }

    it('the getter method is private') { expect(instance).not_to respond_to :hidden_atr }
    it('the setter method is private') { expect(instance).not_to respond_to :hidden_atr= }
  end

  describe '#to_h' do
    subject(:hash) { klass.new(hidden_to_h_atr: :hidden_to_h_atr_val).to_h }

    before { klass.__send__(:hidden, :hidden_to_h_atr) }

    it('does not serialize the attribute') { expect(hash.key?(:hidden_to_h_atr)).to be false }
  end

  context 'when called with true' do
    before { klass.__send__(:hidden, :hidden_t, true) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the getter method is private') { expect(instance).not_to respond_to :hidden_t }
      it('the setter method is private') { expect(instance).not_to respond_to :hidden_t= }
    end

    describe '#to_h' do
      subject(:hash) { klass.new(hidden_t: :hidden_t_val).to_h }

      it('does not serialize the attribute') { expect(hash.key?(:hidden_t)).to be false }
    end
  end

  context 'when called with false' do
    before { klass.__send__(:hidden, :hidden_f, false) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the getter method is public') { expect(instance).to respond_to :hidden_f }
      it('the setter method is public') { expect(instance).to respond_to :hidden_f= }
    end

    describe '#to_h' do
      subject(:hash) { klass.new(hidden_f: :hidden_f_val).to_h }

      it('serializes the attribute') { expect(hash.to_h[:hidden_f]).to be :hidden_f_val }
    end
  end
end
