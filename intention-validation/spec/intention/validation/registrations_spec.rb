module Intention
  describe Validation do
    describe 'registrations' do
      describe '::required!' do
        describe 'initialization' do
          subject(:klass) { Intention.new { required!(:foo) } }

          describe 'when not given a value for the attribute' do
            it 'raises an error' do
              expect { klass.new }.to(
                raise_error(Intention::Validation::RequiredAttributeError),
              )
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

        describe 'when given a custom error' do
          let(:test_error) { Class.new(StandardError) }

          subject(:klass) do
            local_test_error_reference = test_error

            Intention.new { required!(:bar, local_test_error_reference) }
          end

          describe 'when not given a value for the attribute' do
            it 'raises the given custom error' do
              expect { klass.new }.to raise_error(test_error)
            end
          end

          describe 'when given a `nil` value for the attribute' do
            it 'does not raise an error' do
              expect { klass.new(bar: nil) }.not_to raise_error
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            it 'does not raise an error' do
              expect { klass.new(bar: :bar) }.not_to raise_error
            end
          end
        end
      end

      describe '::reject!' do
        describe 'when not given a block' do
          subject(:klass) { Intention.new { reject!(:oops) } }

          it 'raises an error' do
            expect { klass }.to raise_error(Intention::Validation::Reject::BlockRequiredError)
          end
        end

        describe 'initialization' do
          subject(:klass) { Intention.new { reject!(:foo) { |value| value == :reject_me } } }

          describe 'when not given a value for the attribute' do
            it 'does not raise an error' do
              expect { klass.new }.not_to raise_error
            end
          end

          describe 'when the block returns a truthy value' do
            it 'raises an error' do
              expect { klass.new(foo: :reject_me) }.to(
                raise_error(Validation::RejectedAttributeError),
              )
            end
          end

          describe 'when the block returns a falsey value' do
            it 'does not raise an error' do
              expect { klass.new(foo: :dont_reject_me) }.not_to raise_error
            end
          end
        end

        describe 'access' do
          let(:klass) { Intention.new { reject!(:bar) { |value| value == :reject_me_too } } }

          subject(:instance) { klass.new }

          describe 'when the block returns a truthy value' do
            it 'raises an error' do
              expect { instance.bar = :reject_me_too }.to(
                raise_error(Validation::RejectedAttributeError),
              )
            end
          end

          describe 'when the block returns a falsey value' do
            it 'does not raise an error' do
              expect { instance.bar = :dont_reject_me_too }.not_to raise_error
            end
          end
        end

        describe 'when given a custom error' do
          describe 'initialization' do
            let(:test_error) { Class.new(StandardError) }

            subject(:klass) do
              local_test_error_reference = test_error

              Intention.new { reject!(:baz, local_test_error_reference, &:zero?) }
            end

            describe 'when the block returns a truthy value' do
              it 'raises the given custom error' do
                expect { klass.new(baz: 0) }.to raise_error(test_error)
              end
            end
          end

          describe 'access' do
            let(:test_error) { Class.new(StandardError) }

            let(:klass) do
              local_test_error_reference = test_error

              Intention.new { reject!(:qux, local_test_error_reference, &:negative?) }
            end

            subject(:instance) { klass.new }

            describe 'when the block returns a truthy value' do
              it 'raises the given custom error' do
                expect { instance.qux = -1 }.to raise_error(test_error)
              end
            end
          end
        end
      end

      describe '::allow!' do
        describe 'when not given a block' do
          subject(:klass) { Intention.new { allow!(:oops) } }

          it 'raises an error' do
            expect { klass }.to raise_error(Intention::Validation::Allow::BlockRequiredError)
          end
        end

        describe 'initialization' do
          subject(:klass) { Intention.new { allow!(:foo) { |value| value == :allow_me } } }

          describe 'when not given a value for the attribute' do
            it 'does not raise an error' do
              expect { klass.new }.not_to raise_error
            end
          end

          describe 'when the block returns a truthy value' do
            it 'does not raise an error' do
              expect { klass.new(foo: :allow_me) }.not_to raise_error
            end
          end

          describe 'when the block returns a falsey value' do
            it 'raises an error' do
              expect { klass.new(foo: :dont_allow_me) }.to(
                raise_error(Validation::AllowedAttributeError),
              )
            end
          end
        end

        describe 'access' do
          let(:klass) { Intention.new { allow!(:bar) { |value| value == :allow_me_too } } }

          subject(:instance) { klass.new }

          describe 'when the block returns a truthy value' do
            it 'does not raise an error' do
              expect { instance.bar = :allow_me_too }.not_to raise_error
            end
          end

          describe 'when the block returns a falsey value' do
            it 'raises an error' do
              expect { instance.bar = :dont_allow_me_too }.to(
                raise_error(Validation::AllowedAttributeError),
              )
            end
          end
        end

        describe 'when given a custom error' do
          describe 'initialization' do
            let(:test_error) { Class.new(StandardError) }

            subject(:klass) do
              local_test_error_reference = test_error

              Intention.new { allow!(:baz, local_test_error_reference, &:zero?) }
            end

            describe 'when the block returns a falsey value' do
              it 'raises the given custom error' do
                expect { klass.new(baz: -1) }.to raise_error(test_error)
              end
            end
          end

          describe 'access' do
            let(:test_error) { Class.new(StandardError) }

            let(:klass) do
              local_test_error_reference = test_error

              Intention.new { allow!(:qux, local_test_error_reference, &:negative?) }
            end

            subject(:instance) { klass.new }

            describe 'when the block returns a falsey value' do
              it 'raises the given custom error' do
                expect { instance.qux = 0 }.to raise_error(test_error)
              end
            end
          end
        end
      end
    end
  end
end
