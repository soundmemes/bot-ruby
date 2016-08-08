require 'interactor'

module Interactors
  module Sounds
    class Fetch
      include Interactor

      # Finds sounds by query
      #
      # @params
      #   query [String] (Optional)
      #
      # @return
      #   sounds [Array<Sound>]
      #

      def call
        if context.query.to_s.length > 0
          context.sounds = Sound.fetch_by_query(query)
        else
          context.sounds = Sound.fetch_trending
        end
      end
    end
  end
end
