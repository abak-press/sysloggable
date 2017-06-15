require "spec_helper"

describe Sysloggable::Logger do
  let(:syslogger) { spy("syslogger") }
  let(:options) { {ident: "test_ident"} }
  subject(:logger) { described_class.new(options) }

  before do
    Sysloggable::Container.stub('lib.syslogger', syslogger)
  end

  described_class::SEVERITIES.each do |severity_name, severity_value|
    it "responds to #{severity_name}" do
      sev_label = (severity_name == :unknown) ? "ANY" : severity_name.upcase

      expect(syslogger).to receive(:add).
        with(severity_value, "severity=#{sev_label} service=test_ident operation= duration=0 message=msg")

      logger.send(severity_name, "msg")
    end
  end

  context 'duration' do
    context 'when normal task' do
      it "counts duration" do
        Timecop.freeze(Time.now.utc)

        expect(syslogger).to receive(:add).
          with(described_class::SEVERITIES[:info],
               "severity=INFO service=test_ident operation= duration=9.524 message=msg")

        logger.info("msg") do
          Timecop.freeze(Time.now.utc + 9.523531)
        end

        Timecop.return
      end
    end

    context 'when very quick task' do
      it "counts duration" do
        expect(syslogger).to receive(:add).
          with(described_class::SEVERITIES[:info],
               "severity=INFO service=test_ident operation= duration=0.0 message=msg")

        logger.info("msg") do
          # no-op
        end
      end
    end
  end

  context 'when ident is invalid' do
    subject(:logger) { described_class.new(ident: '22222' * 5) }
    it 'raises error' do
      expect{ logger.info('msg') }.to raise_error(ArgumentError)
    end
  end

  context "custom separator" do
    let(:options) { {ident: "test_ident", separator: " | "} }

    it do
      expect(syslogger).to receive(:add).
        with(described_class::SEVERITIES[:info],
             "severity=INFO | service=test_ident | operation= | duration=0 | message=msg")

      logger.info("msg")
    end
  end
end
