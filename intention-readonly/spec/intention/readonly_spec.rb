# frozen_string_literal: true

module Intention
  describe Readonly do
    before { Intention::Readonly.configure }

    describe 'consumer' do
      describe 'without ::readonly' do
        subject do
          Class.new do
            include Intention
            attribute(:foo)
          end
        end

        it 'allows attribute to be read' do
          expect { subject.new.foo }.not_to raise_error
        end

        it 'allows attribute to be written' do
          expect { subject.new.foo = :foo }.not_to raise_error
        end
      end

      describe 'with ::readonly' do
        subject do
          Class.new do
            include Intention
            readonly(:bar)
          end
        end

        it 'allows attribute to be read' do
          expect { subject.new.bar }.not_to raise_error
        end

        it 'does not allow attribute to be written' do
          expect { subject.new.bar = :bar }.to raise_error(NoMethodError)
        end
      end

      it 'can be chained' do
        expect {
          Class.new do
            include Intention
            attribute(:baz).readonly
          end
        }.not_to raise_error
      end
    end
  end
end
