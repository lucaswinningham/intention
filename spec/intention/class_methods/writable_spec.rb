# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::writable', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :writable }
  it('is private') { expect(klass).not_to respond_to :writable }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:writable, :writable_atr)

    expect(klass).to have_received(:attribute).with(:writable_atr)
  end

  describe 'instance accessor' do
    subject(:instance) { klass.new }

    before { klass.__send__(:writable, :writable_atr) }

    it('the setter method is public') { expect(instance).to respond_to :writable_atr= }
  end

  context 'when called with true' do
    before { klass.__send__(:writable, :writable_t, true) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the setter method is public') { expect(instance).to respond_to :writable_t= }
    end
  end

  context 'when called with false' do
    before { klass.__send__(:writable, :writable_f, false) }

    describe 'instance accessor' do
      subject(:instance) { klass.new }

      it('the setter method is private') { expect(instance).not_to respond_to :writable_f= }
    end
  end
end
