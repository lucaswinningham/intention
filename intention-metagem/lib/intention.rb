require 'intention/support'
require 'intention/core'
require 'intention/version'

require 'intention/access'
require 'intention/ingestion'
require 'intention/validation'

Intention::Access.configure
Intention::Ingestion.configure
Intention::Validation.configure
