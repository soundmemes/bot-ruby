require 'resque'
require_relative '../../../lib/utils/logger'
require_relative '../../../lib/utils/redis'
require_relative '../../../lib/utils/sequel'

Resque.before_first_fork do
  $redis.shutdown
  $db.shutdown
  Resque.redis.quit
end

Resque.after_fork do
  $stdout.sync = true
  $logger = Utils::Logger.new(
    name: 'RSQ',
    level: %w(test development).include?(ENV['RACK_ENV']) ? ::MonoLogger::DEBUG : ::MonoLogger::INFO
  )
  $redis = Utils::Redis.new
  $db = Utils::SequelConnection.new
  Resque.redis = Utils::Redis.single_connection
end
