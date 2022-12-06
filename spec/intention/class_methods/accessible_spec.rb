# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::accessible', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :accessible }
  it('is private') { expect(klass).not_to respond_to :accessible }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:accessible, :accessible_atr)

    expect(klass).to have_received(:attribute).with(:accessible_atr)
  end

  context 'when called with true' do
    before { klass.__send__(:accessible, :accessible_t, true) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('defines a getter method') { expect(instance).to have_method :accessible_t }
      it('defines a setter method') { expect(instance).to have_method :accessible_t= }
    end
  end

  context 'when called with false' do
    before { klass.__send__(:accessible, :accessible_f, false) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('does not define a getter method') { expect(instance).not_to have_method :accessible_f }
      it('does not define a setter method') { expect(instance).not_to have_method :accessible_f= }
    end
  end
end
