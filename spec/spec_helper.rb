$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"
SimpleCov.start do
  minimum_coverage 95
end

require "sysloggable"
require "dry/container/stub"
require "timecop"

RSpec.configure do |config|
  config.before { Sysloggable::Container.enable_stubs! }
  config.after { Sysloggable::Container.unstub }
end
