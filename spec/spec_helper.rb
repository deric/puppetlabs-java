require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet/coverage'

at_exit { RSpec::Puppet::Coverage.report! }