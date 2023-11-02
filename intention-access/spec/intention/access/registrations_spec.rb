require 'support/readable'
require 'support/writable'

module Intention
  describe Access do
    describe 'registrations' do
      describe '::accessible' do
        subject(:klass) { Intention.new { accessible(:foo) } }

        include_examples('readable', :foo)
        include_examples('writable', :foo)
      end

      describe '::inaccessible' do
        subject(:klass) { Intention.new { inaccessible(:bar) } }

        include_examples('readable', :bar, :privately)
        include_examples('writable', :bar, :privately)
      end

      describe '::readonly' do
        subject(:klass) { Intention.new { readonly(:baz) } }

        include_examples('readable', :baz)
        include_examples('writable', :baz, :privately)
      end

      describe '::writeonly' do
        subject(:klass) { Intention.new { writeonly(:qux) } }

        include_examples('readable', :qux, :privately)
        include_examples('writable', :qux)
      end

      describe '::ignore_reader' do
        subject(:klass) { Intention.new { ignore_reader(:quux) } }

        include_examples('readable', :quux, false)
        include_examples('writable', :quux)
      end

      describe '::ignore_writer' do
        subject(:klass) { Intention.new { ignore_writer(:corge) } }

        include_examples('readable', :corge)
        include_examples('writable', :corge, false)
      end

      describe '::ignore' do
        subject(:klass) { Intention.new { ignore(:grault) } }

        include_examples('readable', :grault, false)
        include_examples('writable', :grault, false)
      end

      # TODO: same change for other libs
      describe 'chaining' do
        describe 'when ::accessible' do
          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { accessible(:foo).inaccessible } }

            include_examples('readable', :foo, :privately)
            include_examples('writable', :foo, :privately)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { accessible(:bar).readonly } }

            include_examples('readable', :bar)
            include_examples('writable', :bar, :privately)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { accessible(:baz).writeonly } }

            include_examples('readable', :baz, :privately)
            include_examples('writable', :baz)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { accessible(:qux).ignore_reader } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { accessible(:quux).ignore_writer } }

            include_examples('readable', :quux)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { accessible(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::inaccessible' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { inaccessible(:foo).accessible } }

            include_examples('readable', :foo)
            include_examples('writable', :foo)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { inaccessible(:bar).readonly } }

            include_examples('readable', :bar)
            include_examples('writable', :bar, :privately)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { inaccessible(:baz).writeonly } }

            include_examples('readable', :baz, :privately)
            include_examples('writable', :baz)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { inaccessible(:qux).ignore_reader } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux, :privately)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { inaccessible(:quux).ignore_writer } }

            include_examples('readable', :quux, :privately)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { inaccessible(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::readonly' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { readonly(:foo).accessible } }

            include_examples('readable', :foo)
            include_examples('writable', :foo)
          end

          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { readonly(:bar).inaccessible } }

            include_examples('readable', :bar, :privately)
            include_examples('writable', :bar, :privately)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { readonly(:baz).writeonly } }

            include_examples('readable', :baz, :privately)
            include_examples('writable', :baz)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { readonly(:qux).ignore_reader } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux, :privately)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { readonly(:quux).ignore_writer } }

            include_examples('readable', :quux)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { readonly(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::writeonly' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { writeonly(:foo).accessible } }

            include_examples('readable', :foo)
            include_examples('writable', :foo)
          end

          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { writeonly(:bar).inaccessible } }

            include_examples('readable', :bar, :privately)
            include_examples('writable', :bar, :privately)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { writeonly(:baz).readonly } }

            include_examples('readable', :baz)
            include_examples('writable', :baz, :privately)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { writeonly(:qux).ignore_reader } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { writeonly(:quux).ignore_writer } }

            include_examples('readable', :quux, :privately)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { writeonly(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::ignore_reader' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { ignore_reader(:foo).accessible } }

            include_examples('readable', :foo, false)
            include_examples('writable', :foo)
          end

          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { ignore_reader(:bar).inaccessible } }

            include_examples('readable', :bar, false)
            include_examples('writable', :bar, :privately)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { ignore_reader(:baz).readonly } }

            include_examples('readable', :baz, false)
            include_examples('writable', :baz, :privately)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { ignore_reader(:qux).writeonly } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { ignore_reader(:quux).ignore_writer } }

            include_examples('readable', :quux, false)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { ignore_reader(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::ignore_writer' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { ignore_writer(:foo).accessible } }

            include_examples('readable', :foo)
            include_examples('writable', :foo, false)
          end

          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { ignore_writer(:bar).inaccessible } }

            include_examples('readable', :bar, :privately)
            include_examples('writable', :bar, false)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { ignore_writer(:baz).readonly } }

            include_examples('readable', :baz)
            include_examples('writable', :baz, false)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { ignore_writer(:qux).writeonly } }

            include_examples('readable', :qux, :privately)
            include_examples('writable', :qux, false)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { ignore_writer(:quux).ignore_reader } }

            include_examples('readable', :quux, false)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore' do
            subject(:klass) { Intention.new { ignore_writer(:corge).ignore } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end

        describe 'when ::ignore' do
          describe 'is chained with ::accessible' do
            subject(:klass) { Intention.new { ignore(:foo).accessible } }

            include_examples('readable', :foo, false)
            include_examples('writable', :foo, false)
          end

          describe 'is chained with ::inaccessible' do
            subject(:klass) { Intention.new { ignore(:bar).inaccessible } }

            include_examples('readable', :bar, false)
            include_examples('writable', :bar, false)
          end

          describe 'is chained with ::readonly' do
            subject(:klass) { Intention.new { ignore(:baz).readonly } }

            include_examples('readable', :baz, false)
            include_examples('writable', :baz, false)
          end

          describe 'is chained with ::writeonly' do
            subject(:klass) { Intention.new { ignore(:qux).writeonly } }

            include_examples('readable', :qux, false)
            include_examples('writable', :qux, false)
          end

          describe 'is chained with ::ignore_reader' do
            subject(:klass) { Intention.new { ignore(:quux).ignore_reader } }

            include_examples('readable', :quux, false)
            include_examples('writable', :quux, false)
          end

          describe 'is chained with ::ignore_writer' do
            subject(:klass) { Intention.new { ignore(:corge).ignore_writer } }

            include_examples('readable', :corge, false)
            include_examples('writable', :corge, false)
          end
        end
      end
    end
  end
end
