require 'pathname'
dir = Pathname.new(__FILE__).parent
$LOAD_PATH.unshift(dir, File.join(dir, 'fixtures/modules/augeasproviders_core/spec/lib'), File.join(dir, '..', 'lib'))

require 'facter'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'augeas_spec'

unless RUBY_VERSION =~ /^1\.8/
  require 'simplecov'
  require 'coveralls'
end

include RspecPuppetFacts

RSpec.configure do |c|
  c.before(:each) do
    Puppet.features.stubs(:root? => true)
  end
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!(100)
  end
  c.default_facts = { :dbus_startup_provider => 'init' }
end

dir = Pathname.new(__FILE__).parent

Puppet[:modulepath] = File.join(dir, 'fixtures', 'modules')
Puppet[:libdir] = File.join(Puppet[:modulepath], 'augeasproviders_core', 'lib')

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end

unless RUBY_VERSION =~ /^1\.8/
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter 'spec/'
  end
end
