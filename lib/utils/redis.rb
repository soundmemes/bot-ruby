require 'redis'
require 'connection_pool'

module Utils
  class Redis
    DEFAULT_POOL_SIZE = 100.freeze # Per 1 process

    # Closes all the connections and clears the pool
    #
    def shutdown
      @pool.shutdown do |connection|
        connection.quit
      end
    end

    # Gets a connection from pool and yields a given &block
    #
    # @example
    #   Utils::Redis.new.connect { |connection| connection.get('key') }
    #
    def connect(&block)
      @pool.with do |connection|
        yield connection
      end
    end

    # Convenience methods
    #
    # @example
    #   Utils::Redis.new.get('key')
    #   Utils::Redis.new.set('key', :value)
    #   Utils::Redis.new.expire('key', 42)
    #   Utils::Redis.new.del('key')
    #
    def get(key)
      connect do |c|
        c.get(key)
      end
    end

    def set(key, value)
      connect do |c|
        c.set(key, value)
      end
    end

    def expire(key, value)
      connect do |c|
        c.expire(key, value)
      end
    end

    def del(key)
      connect do |c|
        c.del(key)
      end
    end

    def sadd(key, values)
      connect do |c|
        c.sadd(key, values)
      end
    end

    def smembers(key)
      connect do |c|
        c.smembers(key)
      end
    end

    def hset(key, value)
      connect do |c|
        c.hset(key, value)
      end
    end

    def mapped_hmset(key, hash)
      connect do |c|
        c.mapped_hmset(key, hash)
      end
    end

    def hget(key, field)
      connect do |c|
        c.hget(key, field)
      end
    end

    def hgetall(key)
      connect do |c|
        c.hgetall(key)
      end
    end

    def self.single_connection
      ENV['REDIS_URL'] ? ::Redis.new(url: ENV['REDIS_URL']) : ::Redis.new
    end

    private

    def initialize
      @pool = ConnectionPool.new(size: ENV['MAX_REDIS_CONNECTIONS'].to_i | DEFAULT_POOL_SIZE, timeout: 5) do
        Redis.single_connection
      end
    end

    def finalize(id)
      shutdown
    end
  end
end
