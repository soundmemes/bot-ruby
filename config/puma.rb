workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['MAX_THREADS'] || 16)
threads 1, threads_count

quiet ENV['RACK_ENV'] == 'production' ? true : false

preload_app!

rackup      DefaultRackup
port        ENV['PORT'] || 5000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  $logger = Utils::Logger.new(
    name: 'WEB',
    level: %w(test development).include?(ENV['RACK_ENV']) ? ::Logger::DEBUG : ::Logger::INFO
  )
  $db = Utils::SequelConnection.new
  $redis = Utils::Redis.new

  if defined?(Resque)
    Resque.redis = Utils::Redis.single_connection
  end
end

before_fork do
  $db.shutdown
  $redis.shutdown
end
