require "dry/container"
require "syslogger"
require "sysloggable/logger"

module Sysloggable
  Container = ::Dry::Container.new
end

::Sysloggable::Container.namespace('lib') do
  register 'logger', -> { ::Sysloggable::Logger }
  register 'syslogger', -> { ::Syslogger }
end
