require 'support/matchers/have_method'

RSpec.describe '::strict!', type: :class_method do
  include Support::Matchers::HaveMethod

  let(:klass) { Class.new { include Intention } }

  it('is defined') { expect(klass).to have_method :strict! }
  it('is private') { expect(klass).not_to respond_to :strict! }

  describe '#initialize' do
    it('is not strict by default') { expect { klass.new foo: :bar }.not_to raise_error }

    context 'when the class is strict' do
      before { klass.__send__(:strict!) }

      context 'when given extra keys' do
        subject(:instance) { klass.new baz: :qux, quux: :quuz }

        it 'raises an error' do
          expect { instance }.to raise_error(Intention::UnexpectedKeysError, ':baz, :quux')
        end
      end
    end
  end

  context 'when called with true' do
    before { klass.__send__(:strict!, true) }

    context 'when given extra keys' do
      subject(:instance) { klass.new corge: :grault }

      it 'raises an error' do
        expect { instance }.to raise_error(Intention::UnexpectedKeysError)
      end
    end
  end

  context 'when called with false' do
    before { klass.__send__(:strict!, false) }

    context 'when given extra keys' do
      subject(:instance) { klass.new garply: :waldo }

      it('does not raise an error') { expect { instance }.not_to raise_error }
    end
  end
end
