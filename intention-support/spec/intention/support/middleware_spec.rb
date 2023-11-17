class IncrementValue
  def initialize(app, by)
    @app = app
    @by = by
  end

  def call(payload)
    payload[:value] += @by

    @app.call(payload)
  end
end

class MultiplyValue
  def initialize(app, by)
    @app = app
    @by = by
  end

  def call(payload)
    payload[:value] *= @by

    @app.call(payload)
  end
end

module Intention
  describe Support do
    describe Middleware::Builder do
      it 'inherits from ::Middleware::Builder' do
        expect(Support::Middleware::Builder).to be < ::Middleware::Builder
      end

      describe '#upsert' do
        subject(:middleware) { Support::Middleware::Builder.new }

        before { middleware.use(IncrementValue, 1) }

        it 'inserts the given middleware if its class is not present in the stack' do
          middleware.upsert(MultiplyValue, 2)
          payload = { value: 5 }

          middleware.call(payload)

          expect(payload.fetch(:value)).to be(12)
        end

        it 'updates the given middleware if its class is present in the stack' do
          middleware.upsert(IncrementValue, 10)
          payload = { value: 4 }

          middleware.call(payload)

          expect(payload.fetch(:value)).to be(14)
        end
      end
    end
  end
end
