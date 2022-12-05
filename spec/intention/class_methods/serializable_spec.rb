# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.describe '::serializable', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :serializable }
  it('is private') { expect(klass).not_to respond_to :serializable }

  describe '#to_h' do
    it('is not serializable by default') { expect(klass.new).not_to have_method :to_h }

    context 'when the class is serializable' do
      subject(:instance) { klass.new }

      before { klass.__send__(:serializable) }

      it('is defined') { expect(instance).to have_method :to_h }
      it('is public') { expect(instance).to respond_to :to_h }
    end
  end
end
