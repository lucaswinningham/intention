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
      klass.__send__(:attribute, :to_h_atr)
      klass.__send__(:serializable)
    end

    it('serializes the attribute') { expect(hash.to_h[:to_h_atr]).to be :to_h_val }
  end

  describe 'dirty' do
    before { klass.__send__(:dirty) }

    describe 'attribute changes' do
      before { klass.__send__(:attribute, :dirty_atr) }

      it('has a _changed? method') { expect(klass.new).to have_method :dirty_atr_changed? }
      it('has a _was method') { expect(klass.new).to have_method :dirty_atr_was }
      it('has a _change method') { expect(klass.new).to have_method :dirty_atr_change }

      context 'when #initialize is given a value for the attribute' do
        subject(:instance) { klass.new dirty_atr: :dirty_atr_val }

        context 'when the attribute is assigned a different value' do
          subject(:muddify) { instance.dirty_atr = :other_dirty_atr_val }

          it('_changed? is true') do
            expect { muddify }.to change(instance, :dirty_atr_changed?).from(false).to(true)
          end

          it('_was is the previous value') do
            expect { muddify }.to change(instance, :dirty_atr_was).to(:dirty_atr_val)
          end

          it('_change is a hash of the previous value and the current value') do
            expect { muddify }.to change(instance, :dirty_atr_change).to({
              from: :dirty_atr_val,
              to: :other_dirty_atr_val
            })
          end
        end

        context 'when the attribute is not affected' do
          it('_changed? is false') do
            expect { instance }.not_to change(instance, :dirty_atr_changed?).from(false)
          end

          it('_was is ???') do
            expect { instance }.not_to change(instance, :dirty_atr_was).from(:dirty_atr_val)
          end

          it('_change is ???') do
            expect { instance }.to change(instance, :dirty_atr_change).to({
              from: :dirty_atr_val,
              to: :other_dirty_atr_val
            })
          end
        end

        context 'when the attribute is assigned the same value' do
          subject(:reassign) { instance.dirty_atr = :dirty_atr_val }

          it('_changed? is false') do
            expect { reassign }.not_to change(instance, :dirty_atr_changed?).from(false)
          end

          it('_was is ???') do
            expect { reassign }.not_to change(instance, :dirty_atr_was).from(:dirty_atr_val)
          end

          it('_change is ???') do
            expect { reassign }.to change(instance, :dirty_atr_change).to({
              from: :dirty_atr_val,
              to: :other_dirty_atr_val
            })
          end
        end
      end

      context 'when #initialize is not given a value for the attribute' do
        subject(:instance) { klass.new }

        context 'when the attribute is assigned a different value'

        context 'when the attribute is not affected'

        context 'when the attribute is assigned nil'
      end
    end
  end
end
