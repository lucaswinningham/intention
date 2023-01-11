# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.describe '::dirty', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :dirty }
  it('is private') { expect(klass).not_to respond_to :dirty }

  describe 'by default' do
    it('#dirty? is not defined') { expect(klass.new).not_to have_method :dirty? }
  end

  describe '#dirty?' do
    subject(:instance) { klass.new atr1: :atr1_val, atr2: nil }

    before do
      klass.__send__(:dirty)
      klass.__send__(:attribute, :atr1)
      klass.__send__(:attribute, :atr2)
      klass.__send__(:attribute, :atr3)
    end

    it('is defined') { expect(instance).to have_method :dirty? }

    context 'when #initialize is given a value for an attribute' do
      context 'when an attribute is assigned a different value' do
        subject(:muddify) { instance.atr1 = :other_atr1_val }

        it('returns true') { expect { muddify }.to change(instance, :dirty?).from(false).to(true) }
      end

      context 'when an attribute is not affected' do
        it('returns false') { expect { instance }.not_to change(instance, :dirty?).from(false) }
      end

      context 'when an attribute is assigned the same value as was given to #initialize' do
        subject(:reassign) { instance.atr1 = :atr1_val }

        it('returns false') { expect { reassign }.not_to change(instance, :dirty?).from(false) }
      end
    end

    context 'when #initialize is given nil for an attribute' do
      context 'when an attribute is assigned a different value' do
        subject(:muddify) { instance.atr2 = :atr2_val }

        it('returns true') { expect { muddify }.to change(instance, :dirty?).from(false).to(true) }
      end

      context 'when an attribute is not affected' do
        it('returns false') { expect { instance }.not_to change(instance, :dirty?).from(false) }
      end

      context 'when an attribute is assigned nil' do
        subject(:reassign) { instance.atr2 = nil }

        it('returns false') { expect { reassign }.not_to change(instance, :dirty?).from(false) }
      end
    end

    context 'when #initialize is not given a value for the attribute' do
      context 'when an attribute is assigned a different value' do
        subject(:muddify) { instance.atr3 = :atr3_val }

        it('returns true') { expect { muddify }.to change(instance, :dirty?).from(false).to(true) }
      end

      context 'when an attribute is not affected' do
        it('returns false') { expect { instance }.not_to change(instance, :dirty?).from(false) }
      end

      context 'when an attribute is assigned nil' do
        subject(:reassign) { instance.atr3 = nil }

        it('returns false') { expect { reassign }.not_to change(instance, :dirty?).from(false) }
      end
    end
  end

  # describe '#to_h' do
  #   it('does not track dirty by default') do
  #     klass.__send__(:dirty)

  #     expect(klass.new).not_to have_method :to_h
  #   end

  #   context 'when the class is dirty' do
  #     subject(:instance) { klass.new }

  #     before { klass.__send__(:dirty) }

  #     it('is defined') { expect(instance).to have_method :to_h }
  #     it('is public') { expect(instance).to respond_to :to_h }
  #   end
  # end

  describe '#changes'
end
