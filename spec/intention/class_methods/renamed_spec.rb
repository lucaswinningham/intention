# frozen_string_literal: true

require 'support/matchers/have_method'
require 'support/shared/open'

RSpec.describe '::renamed', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :renamed }
  it('is private') { expect(klass).not_to respond_to :renamed }

  it 'calls ::attribute with the attribute name' do
    allow(klass).to receive(:attribute) { Support::Shared::Open.new }

    klass.__send__(:renamed, :renamed_atr, :from_atr)

    expect(klass).to have_received(:attribute).with(:renamed_atr)
  end

  describe '#initialize' do
    before { klass.__send__(:renamed, :renamed_init_atr, :from_init_atr) }

    context 'when given a value for the attribute' do
      subject(:instance) { klass.new from_init_atr: :renamed_init_val }

      it('saves the value') { expect(instance.renamed_init_atr).to be :renamed_init_val }
    end
  end
end
