# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.describe '::attribute', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :attribute }
  it('is private') { expect(klass).not_to respond_to :attribute }

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:attribute, :atr) }

    it('has a getter method') { expect(instance).to have_method :atr }
    it('the getter method is public') { expect(instance).to respond_to :atr }

    it('has a setter method') { expect(instance).to have_method :atr= }
    it('the setter method is public') { expect(instance).to respond_to :atr= }

    context 'when the setter method is called' do
      let(:call) { instance.atr = :val }

      it('changes the value') { expect { call }.to change(instance, :atr).to(:val) }
    end
  end

  describe '#initialize' do
    before { klass.__send__(:attribute, :init_atr) }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new init_atr: :init_val }

      it('does not raise an error') { expect { instance }.not_to raise_error }
      it('saves the value') { expect(instance.init_atr).to be :init_val }
    end

    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it('does not raise an error') { expect { instance }.not_to raise_error }
      it('saves nil') { expect(instance.init_atr).to be_nil }
    end
  end

  describe '#to_h' do
    subject(:hash) { klass.new(to_h_atr: :to_h_val).to_h }

    before do
      klass.__send__(:serializable)
      klass.__send__(:attribute, :to_h_atr)
    end

    it('serializes the attribute') { expect(hash.to_h[:to_h_atr]).to be :to_h_val }
  end
end
