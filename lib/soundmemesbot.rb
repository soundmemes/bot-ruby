require_relative 'utils/sequel'
$db = Utils::SequelConnection.new

Sequel::Model.plugin :dirty
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :defaults_setter

require_relative 'utils/redis'
$redis = Utils::Redis.new
Resque.redis = Utils::Redis.single_connection

require 'interactor'
module Interactors; end

Dir["#{ __dir__ }/soundmemesbot/**/*.rb"].each { |file| require file }
