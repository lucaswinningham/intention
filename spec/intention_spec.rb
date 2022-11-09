# frozen_string_literal: true

require 'support/matchers/include_mixin'

RSpec.describe Intention do
  it 'has a version number' do
    expect(Intention::VERSION).not_to be_nil
  end

  describe 'mixins' do
    include Support::Matchers::IncludeMixin

    let(:klass) do
      Class.new do
        include Intention
      end
    end

    it 'includes Initialization' do
      expect(klass.singleton_class.include?(Intention::Initialization)).to be true
    end

    it 'includes Attribution' do
      expect(klass).to include_mixin Intention::Attribution
    end
  end
end
