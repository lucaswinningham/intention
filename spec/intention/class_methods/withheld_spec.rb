# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::withheld', type: :class_method do
  include Support::Matchers::HaveMethod

  before { klass.__send__(:serializable) }

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :withheld }
  it('is private') { expect(klass).not_to respond_to :withheld }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:withheld, :withheld_atr)

    expect(klass).to have_received(:attribute).with(:withheld_atr)
  end

  describe '#to_h' do
    subject(:hash) { klass.new(withheld_to_h_atr: :withheld_to_h_atr_val).to_h }

    before { klass.__send__(:withheld, :withheld_to_h_atr) }

    it('does not serialize the attribute') { expect(hash.key?(:withheld_to_h_atr)).to be false }
  end

  context 'when called with true' do
    before { klass.__send__(:withheld, :withheld_t, true) }

    describe '#to_h' do
      subject(:hash) { klass.new(withheld_t: :withheld_t_val).to_h }

      it('does not serialize the attribute') { expect(hash.key?(:withheld_t)).to be false }
    end
  end

  context 'when called with false' do
    before { klass.__send__(:withheld, :withheld_f, false) }

    describe '#to_h' do
      subject(:hash) { klass.new(withheld_f: :withheld_f_val).to_h }

      it('serializes the attribute') { expect(hash.to_h[:withheld_f]).to be :withheld_f_val }
    end
  end
end
