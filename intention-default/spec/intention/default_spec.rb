# frozen_string_literal: true

module Intention
  describe Default do
    before { Intention::Default.configure }

    describe 'consumer' do
      describe 'without ::default' do
        subject do
          Class.new do
            include Intention
            attribute(:foo)
          end
        end

        describe 'when the attribute value is not given at initialization' do
          let(:instance) { subject.new }

          it 'attribute value is `nil`' do
            expect(instance.foo).to be_nil
          end
        end
      end

      describe 'with ::default' do
        subject do
          Class.new do
            include Intention
            default(:bar) { :bar_default }
          end
        end

        describe 'when the attribute value is not given at initialization' do
          let(:instance) { subject.new }

          it 'attribute value is the return value of the `default` proc' do
            expect(instance.bar).to be(:bar_default)
          end
        end

        describe 'when the attribute value is given at initialization' do
          let(:instance) { subject.new(bar: :bar) }

          it 'attribute value is the given value' do
            expect(instance.bar).to be(:bar)
          end
        end
      end

      it 'can be chained' do
        expect {
          Class.new do
            include Intention
            attribute(:baz).default
          end
        }.not_to raise_error
      end

      describe 'block' do
        it 'is called when attribute is not given at initialization' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              default(:qux, &block)
            end

            consumer.new
          }.to yield_control
        end

        it 'is not called when attribute is given at initialization' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              default(:quux, &block)
            end

            consumer.new(quux: :quux)
          }.not_to yield_control
        end
      end
    end
  end
end
