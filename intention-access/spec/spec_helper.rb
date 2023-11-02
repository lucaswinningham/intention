require 'bundler/setup'
require 'intention/access'

require_relative '../spec/spec_helper'

RSpec.configure do |config|
  config.before(:all) { Intention::Access.configure }
end
