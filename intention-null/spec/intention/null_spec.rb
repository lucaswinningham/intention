# frozen_string_literal: true

module Intention
  describe Null do
    before { Intention::Null.configure }

    describe 'consumer' do
      describe 'without ::null' do
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

        describe 'when the attribute value given at initialization is `nil`' do
          let(:instance) { subject.new(foo: nil) }

          it 'attribute value is `nil`' do
            expect(instance.foo).to be_nil
          end
        end
      end

      describe 'with ::null' do
        subject do
          Class.new do
            include Intention
            null(:bar) { :not_nil }
          end
        end

        describe 'when the attribute value is not given at initialization' do
          let(:instance) { subject.new }

          it 'attribute value is `nil`' do
            expect(instance.bar).to be_nil
          end
        end

        describe 'when the attribute value given at initialization is `nil`' do
          let(:instance) { subject.new(bar: nil) }

          it 'attribute value is the return value of the `null` proc' do
            expect(instance.bar).to be(:not_nil)
          end
        end

        describe 'when the attribute value given at initialization is not `nil`' do
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
            attribute(:baz).null
          end
        }.not_to raise_error
      end

      describe 'block' do
        it 'is called when attribute given at initialization is `nil`' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              null(:qux, &block)
            end

            consumer.new(qux: nil)
          }.to yield_control
        end

        it 'is not called when attribute given at initialization is not `nil`' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              null(:quux, &block)
            end

            consumer.new(quux: :quux)
          }.not_to yield_control
        end

        it 'is not called when attribute is not given at initialization' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              null(:corge, &block)
            end

            consumer.new
          }.not_to yield_control
        end
      end
    end
  end
end
