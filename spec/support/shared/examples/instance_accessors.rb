# frozen_string_literal: true

require 'support/matchers/have_method'

RSpec.shared_examples 'instance_accessors' do |options = {}|
  include Support::Matchers::HaveMethod

  name = options.fetch(:name) { raise NameRequiredError }

  getter = options.fetch(:getter, {})
  setter = options.fetch(:setter, {})

  if getter.fetch(:defined, true)
    it "defines an instance getter for #{name.inspect}" do
      expect(instance).to have_method name
    end

    it "instance getter for #{name.inspect} gets value" do
      instance.instance_variable_set(:"@#{name}", :getter_value)

      expect(instance.__send__(name)).to be :getter_value
    end

    getter_level = getter.fetch(:level, :public)

    case getter_level
    when :public
      it "instance getter for #{name.inspect} is public" do
        expect(instance).to respond_to name
      end
    when :private
      it "instance getter for #{name.inspect} is private" do
        expect(instance).not_to respond_to name
      end
    end
  else
    it "does not define an instance getter for #{name.inspect}" do
      expect(instance).not_to have_method name
    end
  end

  if setter.fetch(:defined, true)
    it "defines an instance setter for #{name.inspect}" do
      expect(instance).to have_method "#{name}="
    end

    it "instance setter for #{name.inspect} sets value" do
      instance.__send__("#{name}=", :setter_value)

      expect(instance.instance_variable_get(:"@#{name}")).to be :setter_value
    end

    setter_level = setter.fetch(:level, :public)

    case setter_level
    when :public
      it "instance setter for #{name.inspect} is public" do
        expect(instance).to respond_to "#{name}="
      end
    when :private
      it "instance setter for #{name.inspect} is private" do
        expect(instance).not_to respond_to "#{name}="
      end
    end
  else
    it "does not define an instance setter for #{name.inspect}" do
      expect(instance).not_to have_method "#{name}="
    end
  end
end
