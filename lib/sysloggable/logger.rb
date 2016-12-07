module Sysloggable
  class Logger
    SEVERITIES = {
      debug: ::Logger::DEBUG,
      info: ::Logger::INFO,
      warn: ::Logger::WARN,
      error: ::Logger::ERROR,
      fatal: ::Logger::FATAL,
      unknown: ::Logger::UNKNOWN
    }.freeze

    def initialize(options)
      @options = options
    end

    SEVERITIES.each do |logger_method, logger_code|
      define_method logger_method do |*args, &block|
        add(logger_code, *args, &block)
      end
    end

    private

    def logger
      return @logger if defined?(@logger)

      if @options.fetch(:ident).size > 24
        raise ArgumentError.new('Ident lenght must be less then 32 (24 with pid)')
      end

      @logger = Container['lib.syslogger'].new(
        @options.fetch(:ident),
        ::Syslog::LOG_PID | ::Syslog::LOG_CONS,
        ::Syslog::LOG_LOCAL0
      )

      @logger.level = @options.fetch(:level, ::Logger::INFO)
      @logger.push_tags(@options[:tags]) if @options[:tags]

      @logger
    end

    def add(severity, message, params = {})
      if block_given?
        beginning = Time.now.utc
        yield params
        duration = Time.now.utc - beginning
      else
        duration = 0
      end

      formated_message = format_message(severity, message, duration, params)

      logger.add(severity, formated_message)
    end

    def format_message(severity, message, duration, params)
      result = {
        severity: ::Logger::SEV_LABEL[severity],
        service: @options.fetch(:service_name, @options.fetch(:ident)),
        operation: params.delete(:operation),
        duration: duration,
        message: message
      }.merge!(params)

      result.each_with_object(String.new) do |(key, value), memo|
        memo << " " << "#{key}=#{value}"
      end.strip!
    end
  end
end
