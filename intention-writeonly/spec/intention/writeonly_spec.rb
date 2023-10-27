# frozen_string_literal: true

module Intention
  describe Writeonly do
    before { Intention::Writeonly.configure }

    describe 'consumer' do
      describe 'without ::writeonly' do
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

      describe 'with ::writeonly' do
        subject do
          Class.new do
            include Intention
            writeonly(:bar)
          end
        end

        it 'does not allow attribute to be read' do
          expect { subject.new.bar }.to raise_error(NoMethodError)
        end

        it 'allows attribute to be written' do
          expect { subject.new.bar = :bar }.not_to raise_error
        end
      end

      it 'can be chained' do
        expect {
          Class.new do
            include Intention
            attribute(:baz).writeonly
          end
        }.not_to raise_error
      end
    end
  end
end
