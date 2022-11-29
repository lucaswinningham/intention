# frozen_string_literal: true

require 'support/shared'
require 'support/matchers/have_method'

# Expects for caller to implement `subject` and `accessor_name`
RSpec.shared_examples 'accessor' do |options = {}|
  include Support::Matchers::HaveMethod

  let(:accessor_name_eq) do
    "#{accessor_name}="
  end

  getter = options.fetch(:getter, {})
  setter = options.fetch(:setter, {})

  if getter.fetch(:defined, true)
    it('has getter method') { expect(subject).to have_method accessor_name }

    # it 'attribute getter references subject variable with same accessor_name' do
    #   value = Support::Shared.random_string

    #   subject.subject_variable_set(:"@#{accessor_name}", value)

    #   expect(subject.__send__(accessor_name)).to be value
    # end

    getter_level = getter.fetch(:level, :public)

    case getter_level
    when :public
      it('getter method is public') { expect(subject).to respond_to accessor_name }
    when :private
      it('getter method is private') { expect(subject).not_to respond_to accessor_name }
    end
  else
    it('does not have getter method') { expect(subject).not_to have_method accessor_name }
  end

  if setter.fetch(:defined, true)
    it('has setter method') { expect(subject).to have_method accessor_name_eq }

    # it 'attribute setter references subject variable with same name' do
    #   value = Support::Shared.random_string

    #   subject.__send__(accessor_name_eq, value)

    #   expect(subject.subject_variable_get(:"@#{name}")).to be value
    # end

    setter_level = setter.fetch(:level, :public)

    case setter_level
    when :public
      it('setter method is public') { expect(subject).to respond_to accessor_name_eq }
    when :private
      it('setter method is private') { expect(subject).not_to respond_to accessor_name_eq }
    end
  else
    it('does not have setter method') { expect(subject).not_to have_method accessor_name_eq }
  end
end
