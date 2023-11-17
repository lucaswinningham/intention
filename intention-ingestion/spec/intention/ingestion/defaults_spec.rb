module Intention
  describe Ingestion do
    describe 'defaults' do
      describe 'initialization' do
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

    describe 'access' do
      let(:klass) { Intention.new { attribute(:bar) } }

      subject(:instance) { klass.new(bar: nil) }

      describe 'when given a `nil` value for the attribute' do
        before { instance.bar = nil }

        it 'attribute value is `nil`' do
          expect(instance.bar).to be_nil
        end
      end

      describe 'when given a non `nil` value for the attribute' do
        before { instance.bar = :bar }

        it 'attribute value is the given value' do
          expect(instance.bar).to be(:bar)
        end
      end
    end
  end
end
