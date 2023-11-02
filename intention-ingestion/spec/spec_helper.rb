require 'bundler/setup'
require 'intention/ingestion'

require_relative '../spec/spec_helper'

RSpec.configure do |config|
  config.before(:all) { Intention::Ingestion.configure }
end
