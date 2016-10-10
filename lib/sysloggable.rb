require "sysloggable/version"
require "sysloggable/container"

module Sysloggable
  def self.InjectLogger(options)
    Module.new do
      define_method(:logger) do
        @logger ||= Container['lib.logger'].new(options)
      end
    end
  end
end
