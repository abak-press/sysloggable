require "spec_helper"

describe Sysloggable do
  it "has a version number" do
    expect(Sysloggable::VERSION).not_to be nil
  end

  it "defines logger instance method" do
    klass = Class.new do
      include Sysloggable::InjectLogger(ident: "test_name")
    end

    expect(klass.new.logger).to be_a(Sysloggable::Logger)
  end

  it "defines logger class method" do
    klass = Class.new do
      extend Sysloggable::InjectLogger(ident: "test_name")
    end

    expect(klass.logger).to be_a(Sysloggable::Logger)
  end

  it "passes an options to logger" do
    klass = Class.new do
      include Sysloggable::InjectLogger(ident: "test_name")
    end

    expect(klass.new.logger.send(:logger).ident).to eq "test_name"
  end
end
