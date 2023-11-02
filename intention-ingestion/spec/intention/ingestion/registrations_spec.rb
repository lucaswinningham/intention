module Intention
  describe Ingestion do
    describe 'registrations' do
      describe '::default' do
        describe 'when given a block' do
          subject { Intention.new { default(:foo) { :not_nil } } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is `nil`' do
                expect(instance.foo).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end
        end

        describe 'when not given a block' do
          subject { Intention.new { default(:bar) } }

          describe 'when not given a value for the attribute' do
            let(:instance) { subject.new }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a `nil` value for the attribute' do
            let(:instance) { subject.new(bar: nil) }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            let(:instance) { subject.new(bar: :bar) }

            it 'attribute value is the given value' do
              expect(instance.bar).to be(:bar)
            end
          end
        end
      end

      describe '::null' do
        describe 'when given a block' do
          subject { Intention.new { null(:foo) { :not_nil } } }

          describe 'when not given a value for the attribute' do
            let(:instance) { subject.new }

            it 'attribute value is `nil`' do
              expect(instance.foo).to be_nil
            end
          end

          describe 'when given a `nil` value for the attribute' do
            let(:instance) { subject.new(foo: nil) }

            it 'attribute value is the return value of the given block' do
              expect(instance.foo).to be(:not_nil)
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            let(:instance) { subject.new(foo: :foo) }

            it 'attribute value is the given value' do
              expect(instance.foo).to be(:foo)
            end
          end
        end

        describe 'when not given a block' do
          subject { Intention.new { null(:bar) } }

          describe 'when not given a value for the attribute' do
            let(:instance) { subject.new }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a `nil` value for the attribute' do
            let(:instance) { subject.new(bar: nil) }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            let(:instance) { subject.new(bar: :bar) }

            it 'attribute value is the given value' do
              expect(instance.bar).to be(:bar)
            end
          end
        end
      end

      describe '::coerce' do
        describe 'when given a block' do
          subject { Intention.new { coerce(:foo) { :not_nil } } }

          describe 'when not given a value for the attribute' do
            let(:instance) { subject.new }

            it 'attribute value is the return value of the given block' do
              expect(instance.foo).to be(:not_nil)
            end
          end

          describe 'when given a `nil` value for the attribute' do
            let(:instance) { subject.new(foo: nil) }

            it 'attribute value is the return value of the given block' do
              expect(instance.foo).to be(:not_nil)
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            let(:instance) { subject.new(foo: :foo) }

            it 'attribute value is the given value' do
              expect(instance.foo).to be(:foo)
            end
          end
        end

        describe 'when not given a block' do
          subject { Intention.new { coerce(:bar) } }

          describe 'when not given a value for the attribute' do
            let(:instance) { subject.new }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a `nil` value for the attribute' do
            let(:instance) { subject.new(bar: nil) }

            it 'attribute value is `nil`' do
              expect(instance.bar).to be_nil
            end
          end

          describe 'when given a non `nil` value for the attribute' do
            let(:instance) { subject.new(bar: :bar) }

            it 'attribute value is the given value' do
              expect(instance.bar).to be(:bar)
            end
          end
        end
      end

      describe 'chaining' do
        describe 'when ::default' do
          describe 'is chained with ::null' do
            subject { Intention.new { default(:foo) { :default }.null { :null } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::default block' do
                expect(instance.foo).to be(:default)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::null block' do
                expect(instance.foo).to be(:null)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end

          describe 'is chained with ::coerce' do
            subject { Intention.new { default(:foo) { :default }.coerce { :coerce } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end
        end

        describe 'when ::null' do
          describe 'is chained with ::default' do
            subject { Intention.new { null(:foo) { :null }.default { :default } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::default block' do
                expect(instance.foo).to be(:default)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::null block' do
                expect(instance.foo).to be(:null)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end

          describe 'is chained with ::coerce' do
            subject { Intention.new { null(:foo) { :null }.coerce { :coerce } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end
        end

        describe 'when ::coerce' do
          describe 'is chained with ::default' do
            subject { Intention.new { coerce(:foo) { :coerce }.default { :default } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::default block' do
                expect(instance.foo).to be(:default)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end

          describe 'is chained with ::null' do
            subject { Intention.new { coerce(:foo) { :coerce }.null { :null } } }

            describe 'when not given a value for the attribute' do
              let(:instance) { subject.new }

              it 'attribute value is the return value of the given ::coerce block' do
                expect(instance.foo).to be(:coerce)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { subject.new(foo: nil) }

              it 'attribute value is the return value of the given ::null block' do
                expect(instance.foo).to be(:null)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { subject.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end
        end
      end
    end
  end
end
