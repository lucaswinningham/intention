require 'support/readable'
require 'support/writable'

module Intention
  describe Access do
    describe 'defaults' do
      describe '::attribute' do
        subject { Intention.new { attribute(:foo) } }

        include_examples('readable', :foo)
        include_examples('writable', :foo)
      end

      describe 'instance' do
        subject(:klass) { Intention.new { attribute(:bar) } }

        describe 'initialization' do
          describe 'when given a value for the attribute' do
            let(:instance) { klass.new(bar: :bar) }

            it 'getter returns with given value' do
              expect(instance.bar).to be(:bar)
            end
          end

          describe 'when not given a value for the attribute' do
            let(:instance) { klass.new }

            it 'getter returns with `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a value for an unexpected attribute' do
            let(:input) { { foo: :foo } }

            it 'does not error' do
              expect { klass.new(input) }.not_to raise_error
            end
          end
        end
      end
    end
  end
end
