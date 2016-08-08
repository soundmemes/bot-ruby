require 'mono_logger'

module Utils
  class Logger
    DEFAULT_LEVEL    = ::MonoLogger::DEBUG
    DEFAULT_PROGNAME = 'BOT'.freeze

    attr_reader :logger

    def initialize(options = {})
      @logger = ::MonoLogger.new($stdout)
      @logger.level = options.fetch(:level, DEFAULT_LEVEL)
      @logger.progname = options.fetch(:name, DEFAULT_PROGNAME)
      @logger
    end

    %w(log debug info warn error fatal).each do |m|
      define_method m do |args|
        @logger.send(m, args)
      end
    end

    def close
      @logger.close
    end
  end
end
