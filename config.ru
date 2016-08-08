started_at = Time.now

ENV['RACK_ENV'] ||= 'development'

require 'dotenv'
Dotenv.load('.env', ".env.#{ ENV['RACK_ENV'] }")

require 'byebug' if ENV['RACK_ENV'] == 'development'

require_relative 'lib/utils/logger'
$stdout.sync = true
$logger = Utils::Logger.new(
  name: 'WEB',
  level: %w(test development).include?(ENV['RACK_ENV']) ? ::MonoLogger::DEBUG : ::MonoLogger::INFO
)

require_relative 'config/environment'

require 'resque/server'
require 'resque/scheduler/server'

puts "[#{ Process.pid }] * Loaded in #{ ENV['RACK_ENV'] } environment in #{ ((Time.now - started_at) * 1000).floor }ms!"

run Rack::URLMap.new(
  '/resque' => Resque::Server.new.freeze,
  '/' => proc { [200, {}, ["418 I'm a teapot"]] }
)
