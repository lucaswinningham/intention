module Intention
  describe Validation do
    describe 'defaults' do
      describe '::attribute' do
        subject(:klass) { Intention.new { attribute(:foo) } }

        it 'allows the attribute to not be given at initialization' do
          expect { klass.new }.not_to raise_error
        end
      end
    end
  end
end
