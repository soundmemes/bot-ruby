require 'byebug' if ENV['RACK_ENV'] == 'development'

require_relative 'settings'
Dir["#{ __dir__ }/initializers/**/*.rb"].each { |file| require file }

require_relative '../lib/soundmemesbot'
