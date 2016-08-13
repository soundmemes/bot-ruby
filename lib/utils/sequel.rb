require 'sequel'
require 'connection_pool'

module Utils
  class SequelConnection
    DEFAULT_POOL_SIZE = 20.freeze # Per 1 process

    attr_reader :db

    def shutdown
      @db.disconnect
    end

    def [](args)
      @db.[](args)
    end

    private

    def initialize
      options = {
        max_connections: ENV['MAX_DB_CONNECTIONS'].to_i | DEFAULT_POOL_SIZE,
        loggers: [Utils::Logger.new(
          name: 'SQL',
          level: %w(test development).include?(ENV['RACK_ENV']) ? ::MonoLogger::DEBUG : ::MonoLogger::WARN
        )]
      }

      @db = Sequel.connect(ENV['DATABASE_URL'], options)
      @db.extension :pg_array,
                    :pg_json,
                    :pg_inet,
                    :connection_validator
      @db.sql_log_level = :info

      @db
    end

    def finalize(id)
      shutdown
    end
  end
end
