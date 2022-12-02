# frozen_string_literal: true

require 'support/matchers/have_method'
# require 'support/shared/examples/accessor'

RSpec.describe '::attribute', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :attribute }
  it('is private') { expect(klass).not_to respond_to :attribute }

  describe 'instance accessor' do
    before { klass.__send__(:attribute, :atr) }

    subject(:instance) { klass.new }

    it('has getter method') { expect(subject).to have_method :atr }
    it('getter method is public') { expect(subject).to respond_to :atr }

    it('has setter method') { expect(subject).to have_method :atr= }
    it('setter method is public') { expect(subject).to respond_to :atr= }
    it 'setter method changes the underlying value' do
      expect { subject.atr = :val }.to change { subject.atr }.to(:val)
    end
  end

  describe '#initialize' do
    before { klass.__send__(:attribute, :init_atr) }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new init_atr: :init_val }

      it('does not raise error') { expect { instance }.not_to raise_error }
      it('saves value') { expect(instance.init_atr).to be :init_val }
    end

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it('does not raise error') { expect { instance }.not_to raise_error }
      it('saves nil') { expect(instance.init_atr).to be_nil }
    end
  end
end
