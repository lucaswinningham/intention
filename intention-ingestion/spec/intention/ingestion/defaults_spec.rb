module Intention
  describe Ingestion do
    describe 'defaults' do
      subject(:klass) { Intention.new { attribute(:foo) } }

      describe 'when not given a value for the attribute' do
        let(:instance) { klass.new }

        it 'attribute value is `nil`' do
          expect(instance.foo).to be_nil
        end
      end

      describe 'when given a `nil` value for the attribute' do
        let(:instance) { klass.new(foo: nil) }

        it 'attribute value is `nil`' do
          expect(instance.foo).to be_nil
        end
      end

      describe 'when given a non `nil` value for the attribute' do
        let(:instance) { klass.new(foo: :foo) }

        it 'attribute value is the given value' do
          expect(instance.foo).to be(:foo)
        end
      end
    end
  end
end
