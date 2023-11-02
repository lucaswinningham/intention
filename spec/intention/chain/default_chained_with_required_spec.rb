RSpec.describe '::default chained with ::required', type: :chain do
  let(:klass) do
    Class.new do
      include Intention

      default(:default_chained_with_required_atr).required
    end
  end

  describe '#initialize' do
    context 'when not given a value for the attribute' do
      subject(:instance) { klass.new }

      it('raises an error') do
        expect { instance }.to raise_error(Intention::RequiredAttributeError)
      end
    end
  end
end
