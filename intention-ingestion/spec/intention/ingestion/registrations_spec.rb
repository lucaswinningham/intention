module Intention
  describe Ingestion do
    describe 'registrations' do
      describe '::loads' do
        describe 'when given a block' do
          subject(:klass) { Intention.new { loads(:foo) { :not_nil } } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.foo).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(foo: nil) }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(foo: :foo) }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(foo: :foo) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.foo = nil }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.foo = :foo_too }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end
          end
        end

        describe 'when not given a block' do
          subject(:klass) { Intention.new { loads(:bar) } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(bar: nil) }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(bar: :bar) }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(bar: :bar) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.bar = nil }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.bar = :bar_too }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar_too)
              end
            end
          end
        end
      end

      describe '::default' do
        describe 'when given a block' do
          subject(:klass) { Intention.new { default(:foo) { :not_nil } } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
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

          describe 'access' do
            subject(:instance) { klass.new(foo: :foo) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.foo = nil }

              it 'attribute value is `nil`' do
                expect(instance.foo).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.foo = :foo_too }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo_too)
              end
            end
          end
        end

        describe 'when not given a block' do
          subject(:klass) { Intention.new { default(:bar) } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(bar: nil) }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(bar: :bar) }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(bar: :bar) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.bar = nil }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.bar = :bar_too }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar_too)
              end
            end
          end
        end
      end

      describe '::null' do
        describe 'when given a block' do
          subject(:klass) { Intention.new { null(:foo) { :not_nil } } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.foo).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(foo: nil) }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(foo: :foo) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.foo = nil }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.foo = :foo_too }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo_too)
              end
            end
          end
        end

        describe 'when not given a block' do
          subject(:klass) { Intention.new { null(:bar) } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(bar: nil) }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(bar: :bar) }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(bar: :bar) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.bar = nil }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.bar = :bar_too }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar_too)
              end
            end
          end
        end
      end

      describe '::coerce' do
        describe 'when given a block' do
          subject(:klass) { Intention.new { coerce(:foo) { :not_nil } } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(foo: nil) }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(foo: :foo) }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(foo: :foo) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.foo = nil }

              it 'attribute value is the return value of the given block' do
                expect(instance.foo).to be(:not_nil)
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.foo = :foo_too }

              it 'attribute value is the given value' do
                expect(instance.foo).to be(:foo_too)
              end
            end
          end
        end

        describe 'when not given a block' do
          subject(:klass) { Intention.new { coerce(:bar) } }

          describe 'initialization' do
            describe 'when not given a value for the attribute' do
              let(:instance) { klass.new }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a `nil` value for the attribute' do
              let(:instance) { klass.new(bar: nil) }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              let(:instance) { klass.new(bar: :bar) }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar)
              end
            end
          end

          describe 'access' do
            subject(:instance) { klass.new(bar: :bar) }

            describe 'when given a `nil` value for the attribute' do
              before { instance.bar = nil }

              it 'attribute value is `nil`' do
                expect(instance.bar).to be_nil
              end
            end

            describe 'when given a non `nil` value for the attribute' do
              before { instance.bar = :bar_too }

              it 'attribute value is the given value' do
                expect(instance.bar).to be(:bar_too)
              end
            end
          end
        end
      end

      describe 'chaining' do
        describe 'when ::loads' do
          describe 'is chained with ::default' do
            subject(:klass) { Intention.new { loads(:foo) { :loads }.default { :default } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(foo: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(foo: :foo) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(foo: :foo) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.foo = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.foo = :foo_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end
          end

          describe 'is chained with ::null' do
            subject(:klass) { Intention.new { loads(:bar) { :loads }.null { :null } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is `nil`' do
                  expect(instance.bar).to be_nil
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(bar: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.bar).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(bar: :bar) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.bar).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(bar: :bar) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.bar = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.bar).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.bar = :bar_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.bar).to be(:loads)
                end
              end
            end
          end

          describe 'is chained with ::coerce' do
            subject(:klass) { Intention.new { loads(:baz) { :loads }.coerce { :coerce } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.baz).to be(:loads)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(baz: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.baz).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(baz: :baz) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.baz).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(baz: :baz) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.baz = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.baz).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.baz = :baz_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.baz).to be(:loads)
                end
              end
            end
          end
        end

        describe 'when ::default' do
          describe 'is chained with ::loads' do
            subject(:klass) { Intention.new { default(:foo) { :default }.loads { :loads } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(foo: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(foo: :foo) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(foo: :foo) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.foo = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.foo = :foo_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end
          end

          describe 'is chained with ::null' do
            subject(:klass) { Intention.new { default(:bar) { :default }.null { :null } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::default block' do
                  expect(instance.bar).to be(:default)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(bar: nil) }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.bar).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(bar: :bar) }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(bar: :bar) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.bar = nil }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.bar).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.bar = :bar_too }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar_too)
                end
              end
            end
          end

          describe 'is chained with ::coerce' do
            subject(:klass) { Intention.new { default(:baz) { :default }.coerce { :coerce } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(baz: nil) }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(baz: :baz) }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(baz: :baz) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.baz = nil }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.baz = :baz_too }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz_too)
                end
              end
            end
          end
        end

        describe 'when ::null' do
          describe 'is chained with ::loads' do
            subject(:klass) { Intention.new { null(:foo) { :null }.loads { :loads } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is `nil`' do
                  expect(instance.foo).to be_nil
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(foo: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(foo: :foo) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(foo: :foo) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.foo = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.foo = :foo_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end
          end

          describe 'is chained with ::default' do
            subject(:klass) { Intention.new { null(:bar) { :null }.default { :default } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::default block' do
                  expect(instance.bar).to be(:default)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(bar: nil) }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.bar).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(bar: :bar) }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(bar: :bar) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.bar = nil }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.bar).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.bar = :bar_too }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar_too)
                end
              end
            end
          end

          describe 'is chained with ::coerce' do
            subject(:klass) { Intention.new { null(:baz) { :null }.coerce { :coerce } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(baz: nil) }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.baz).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(baz: :baz) }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(baz: :baz) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.baz = nil }

                it 'attribute value is the return value of the given ::null block' do
                  expect(instance.baz).to be(:null)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.baz = :baz_too }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz_too)
                end
              end
            end
          end
        end

        describe 'when ::coerce' do
          describe 'is chained with ::loads' do
            subject(:klass) { Intention.new { coerce(:foo) { :coerce }.loads { :loads } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(foo: nil) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(foo: :foo) }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(foo: :foo) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.foo = nil }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.foo = :foo_too }

                it 'attribute value is the return value of the given ::loads block' do
                  expect(instance.foo).to be(:loads)
                end
              end
            end
          end

          describe 'is chained with ::default' do
            subject(:klass) { Intention.new { coerce(:bar) { :coerce }.default { :default } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::default block' do
                  expect(instance.bar).to be(:default)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(bar: nil) }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.bar).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(bar: :bar) }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(bar: :bar) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.bar = nil }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.bar).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.bar = :bar_too }

                it 'attribute value is the given value' do
                  expect(instance.bar).to be(:bar_too)
                end
              end
            end
          end

          describe 'is chained with ::null' do
            subject(:klass) { Intention.new { coerce(:baz) { :coerce }.null { :null } } }

            describe 'initialization' do
              describe 'when not given a value for the attribute' do
                let(:instance) { klass.new }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a `nil` value for the attribute' do
                let(:instance) { klass.new(baz: nil) }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                let(:instance) { klass.new(baz: :baz) }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz)
                end
              end
            end

            describe 'access' do
              subject(:instance) { klass.new(baz: :baz) }

              describe 'when given a `nil` value for the attribute' do
                before { instance.baz = nil }

                it 'attribute value is the return value of the given ::coerce block' do
                  expect(instance.baz).to be(:coerce)
                end
              end

              describe 'when given a non `nil` value for the attribute' do
                before { instance.baz = :baz_too }

                it 'attribute value is the given value' do
                  expect(instance.baz).to be(:baz_too)
                end
              end
            end
          end
        end
      end
    end
  end
end
