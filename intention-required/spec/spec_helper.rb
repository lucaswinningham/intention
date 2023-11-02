require 'bundler/setup'
require 'intention/required'

require_relative '../spec/spec_helper'

RSpec.configure do |config|
  config.before(:all) { Intention::Required.configure }
end
