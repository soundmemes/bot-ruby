started_at = Time.now

ENV['RACK_ENV'] ||= 'development'

require 'dotenv'
Dotenv.load('.env', ".env.#{ ENV['RACK_ENV'] }")

require 'byebug' if ENV['RACK_ENV'] == 'development'

require_relative 'lib/utils/logger'
$stdout.sync = true
$logger = Utils::Logger.new(
  name: 'BOT',
  level: %w(test development).include?(ENV['RACK_ENV']) ? ::MonoLogger::DEBUG : ::MonoLogger::INFO
)

require_relative 'config/environment'
require_relative 'apps/bot/bot'

puts "[#{ Process.pid }] * Loaded in #{ ENV['RACK_ENV'] } environment in #{ ((Time.now - started_at) * 1000).floor }ms!"

Apps::Bot::Bot.instance.run
