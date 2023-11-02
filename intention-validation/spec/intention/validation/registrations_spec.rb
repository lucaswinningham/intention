module Intention
  describe Validation do
    describe 'registrations' do
      describe '::required!' do
        it 'requires the attribute to be given at initialization' do
          expect { Intention.new { required!(:bar) }.new }.to(
            raise_error(Intention::Validation::RequiredAttributeError)
          )
        end

        # # TODO: add chaining after moving to `intention-validation`
        # it 'can be chained' do
        #   expect { Intention.new { attribute(:baz).required! } }.not_to raise_error
        # end

        describe 'when given a custom error' do
          let(:test_error) { Class.new(StandardError) }

          subject(:klass) do
            local_test_error = test_error

            Intention.new { required!(:qux, local_test_error) }
          end

          describe 'when the attribute is not given at initialization' do
            let(:instance) { klass.new }

            it 'raises the given custom error' do
              expect { instance }.to raise_error(test_error)
            end
          end
        end

        describe 'when given a block' do
          describe 'when the attribute is not given at initialization' do
            it 'calls the given block' do
              expect { |block| Intention.new { required!(:quux, &block) }.new }.to yield_control
            end

            describe 'when the given block returns a falsey value' do
              let(:block) { proc {} }

              subject(:klass) do
                local_block = block

                Intention.new { required!(:grault, &local_block) }
              end

              it 'allows the attribute to not be given at initialization' do
                expect { klass.new }.not_to raise_error
              end
            end

            describe 'when the given block returns a truthy value' do
              let(:block) { proc { :truthy } }

              subject(:klass) do
                local_block = block

                Intention.new { required!(:grault, &local_block) }
              end

              it 'requires the attribute to be given at initialization' do
                expect { klass.new }.to raise_error(Intention::Validation::RequiredAttributeError)
              end
            end
          end

          describe 'when the attribute is given at initialization' do
            it 'does not call the given block' do
              expect { |block|
                Intention.new { required!(:corge, &block) }.new(corge: :corge)
              }.not_to yield_control
            end
          end
        end
      end
    end
  end
end
