require 'bundler/setup'
require 'intention/validation'

require_relative '../spec/spec_helper'

RSpec.configure do |config|
  config.before(:all) { Intention::Validation.configure }
end
