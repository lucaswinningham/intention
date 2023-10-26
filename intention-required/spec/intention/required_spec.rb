# frozen_string_literal: true

module Intention
  describe Required do
    before { Intention::Required.configure }

    describe 'consumer' do
      describe 'without ::required!' do
        subject do
          Class.new do
            include Intention
            attribute(:foo)
          end
        end

        it 'allows attribute to not be given at initialization' do
          expect { subject.new }.not_to raise_error
        end
      end

      describe 'with ::required!' do
        subject do
          Class.new do
            include Intention
            required!(:bar)
          end
        end

        it 'requires attribute to be given at initialization' do
          expect { subject.new }.to raise_error(Intention::RequiredAttributeError)
        end
      end

      it 'can be chained' do
        expect {
          Class.new do
            include Intention
            attribute(:baz).required!
          end
        }.not_to raise_error
      end

      describe 'custom error' do
        let(:test_error) { Class.new(StandardError) }

        subject do
          local_test_error = test_error

          Class.new do
            include Intention
            required!(:qux, local_test_error)
          end
        end

        it 'raises custom error when attribute is not given at initialization' do
          expect { subject.new }.to raise_error(test_error)
        end
      end

      describe 'block' do
        it 'is called when attribute is not given at initialization' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              required!(:quux, &block)
            end

            consumer.new
          }.to yield_control
        end

        it 'is not called when attribute is given at initialization' do
          block = proc {}

          expect { |block|
            consumer = Class.new do
              include Intention
              required!(:corge, &block)
            end

            consumer.new(corge: :corge)
          }.not_to yield_control
        end

        describe 'when it returns falsey' do
          let(:block) { proc { nil } }
  
          subject do
            local_block = block
  
            Class.new do
              include Intention
              required!(:grault, &local_block)
            end
          end

          it 'allows attribute to not be given at initialization' do
            expect { subject.new }.not_to raise_error
          end
        end

        describe 'when it returns truthy' do
          let(:block) { proc { :truthy } }
  
          subject do
            local_block = block
  
            Class.new do
              include Intention
              required!(:garply, &local_block)
            end
          end

          it 'requires attribute to be given at initialization' do
            expect { subject.new }.to raise_error(Intention::RequiredAttributeError)
          end
        end
      end
    end
  end
end
