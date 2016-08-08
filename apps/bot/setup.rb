require_relative 'shared'

Dir["#{ __dir__ }/actions/**/*.rb"].each { |file| require file }
Dir["#{ __dir__ }/errors/**/*.rb"].each { |file| require file }
Dir["#{ __dir__ }/handlers/**/*.rb"].each { |file| require file }
Dir["#{ __dir__ }/keyboards/**/*.rb"].each { |file| require file }
Dir["#{ __dir__ }/responders/**/*.rb"].each { |file| require file }
Dir["#{ __dir__ }/utils/**/*.rb"].each { |file| require file }
