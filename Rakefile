require 'rake'

ENV['RACK_ENV'] ||= 'development'
require 'dotenv'
Dotenv.load('.env', ".env.#{ ENV['RACK_ENV'] }")

task :environment do
  require_relative 'config/environment'
end

desc 'Run console'
task console: :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end

namespace :db do
  desc "Run DB migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"

    Sequel.extension :migration
    db = Sequel.connect(ENV['DATABASE_URL'])
    db.extension :pg_array,
                 :pg_json

    if args[:version]
      if ENV['RACK_ENV'] == 'production'
        raise 'Can migrate only to latest in production!'
      end
      puts "Migrating to version #{ args[:version] }"
      Sequel::Migrator.run(db, "#{ File.dirname(__FILE__) }/db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "#{ File.dirname(__FILE__) }/db/migrations")
    end
  end

  desc 'Clear DB and run migrations from scratch'
  task :reset do
    if ENV['RACK_ENV'] == 'production'
      raise 'Cannot reset DB in production!'
    end

    require "sequel"
    Sequel.extension :migration
    db = Sequel.connect(ENV['DATABASE_URL'])
    db.extension :pg_array,
                 :pg_json

    puts "Resetting DB"
    Sequel::Migrator.run(db, "#{ File.dirname(__FILE__) }/db/migrations", target: 0)
    Sequel::Migrator.run(db, "#{ File.dirname(__FILE__) }/db/migrations")
  end

  desc 'Seed'
  task seed: :environment do
    require_relative 'db/seed'
  end
end

require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'yaml'

namespace :resque do
  task setup: :environment do
    require_relative 'config/initializers/resque/resque'
  end

  task setup_schedule: :setup do
    require_relative 'config/initializers/resque/resque_scheduler'
  end

  task scheduler: :setup_schedule
end
