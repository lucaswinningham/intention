require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::expected', type: :class_method do
  include Support::Matchers::HaveMethod

  before { klass.__send__ :strict! }

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :expected }
  it('is private') { expect(klass).not_to respond_to :expected }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:expected, :expected_atr)

    expect(klass).to have_received(:attribute).with(:expected_atr)
  end

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:expected, :expected_atr) }

    it('the getter method is not defined') { expect(instance).not_to have_method :expected_atr }
    it('the setter method is not defined') { expect(instance).not_to have_method :expected_atr= }
  end

  describe '#to_h' do
    subject(:hash) { klass.new(expected_to_h_atr: :expected_to_h_atr_val).to_h }

    before do
      klass.__send__(:serializable)
      klass.__send__(:expected, :expected_to_h_atr)
    end

    it('does not serialize the attribute') { expect(hash.key?(:expected_to_h_atr)).to be false }
  end
end
