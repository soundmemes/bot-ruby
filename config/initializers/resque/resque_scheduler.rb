require 'yaml'
require 'resque-scheduler'

Resque::Scheduler.dynamic = true
# Resque.schedule = YAML.load_file("#{ File.dirname(__FILE__) }/resque_schedule.yml")
