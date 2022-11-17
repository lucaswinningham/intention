# frozen_string_literal: true

RSpec.describe 'Intention::VERSION', type: :version do
  it 'is defined' do
    expect(Intention::VERSION).not_to be_nil
  end
end
