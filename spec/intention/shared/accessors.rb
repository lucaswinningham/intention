# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.shared_examples 'accessors' do |options = {}|
  class NameRequiredError < StandardError; end

  include Support::Matchers::HaveMethod

  # let(:instance) { klass.new name => attribute_value }

  name = options.fetch(:name) { raise NameRequiredError }

  getter = options.fetch(:getter, {})
  setter = options.fetch(:setter, {})

  if getter.fetch(:defined, true)
    it "defines a getter for ##{name}" do
      expect(subject).to have_method name
    end

    it "getter for ##{name} gets value" do
      subject.instance_variable_set(:"@#{name}", :getter_value)

      expect(subject.__send__(name)).to be :getter_value
    end

    getter_level = getter.fetch(:level, :public)

    case getter_level
    when :public
      it "getter for ##{name} is public" do
        expect(subject).to respond_to name
      end
    when :private
      it "getter for ##{name} is private" do
        expect(subject).not_to respond_to name
      end
    end
  end

  if setter.fetch(:defined, true)
    it "defines a setter for ##{name}" do
      expect(subject).to have_method "#{name}="
    end

    it "setter for ##{name} sets value" do
      subject.__send__("#{name}=", :setter_value)

      expect(subject.instance_variable_get(:"@#{name}")).to be :setter_value
    end

    setter_level = setter.fetch(:level, :public)

    case setter_level
    when :public
      it "setter for ##{name} is public" do
        expect(subject).to respond_to "#{name}="
      end
    when :private
      it "setter for ##{name} is private" do
        expect(subject).not_to respond_to "#{name}="
      end
    end
  end
end
