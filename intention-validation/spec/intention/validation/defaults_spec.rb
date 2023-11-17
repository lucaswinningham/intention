module Intention
  describe Validation do
    describe 'defaults' do
      describe 'initialization' do
        subject(:klass) { Intention.new { attribute(:foo) } }

        describe 'when not given a value for the attribute' do
          it 'does not raise an error' do
            expect { klass.new }.not_to raise_error
          end
        end

        describe 'when given a `nil` value for the attribute' do
          it 'does not raise an error' do
            expect { klass.new(foo: nil) }.not_to raise_error
          end
        end

        describe 'when given a non `nil` value for the attribute' do
          it 'does not raise an error' do
            expect { klass.new(foo: :foo) }.not_to raise_error
          end
        end
      end

      describe 'access' do
        let(:klass) { Intention.new { attribute(:bar) } }

        subject(:instance) { klass.new }

        describe 'when given a `nil` value for the attribute' do
          it 'does not raise an error' do
            expect { instance.bar = nil }.not_to raise_error
          end
        end

        describe 'when given a non `nil` value for the attribute' do
          it 'does not raise an error' do
            expect { instance.bar = :bar }.not_to raise_error
          end
        end
      end
    end
  end
end
