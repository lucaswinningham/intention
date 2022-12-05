# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::readable', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :readable }
  it('is private') { expect(klass).not_to respond_to :readable }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:readable, :readable_atr)

    expect(klass).to have_received(:attribute).with(:readable_atr)
  end

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:readable, :readable_atr) }

    it('the getter method is public') { expect(instance).to respond_to :readable_atr }
  end

  context 'when called with true' do
    before { klass.__send__(:readable, :readable_t, true) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the getter method is public') { expect(instance).to respond_to :readable_t }
    end
  end

  context 'when called with false' do
    before { klass.__send__(:readable, :readable_f, false) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the getter method is private') { expect(instance).not_to respond_to :readable_f }
    end
  end
end
