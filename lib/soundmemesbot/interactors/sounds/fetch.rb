require 'interactor'

module Interactors
  module Sounds
    class Fetch
      include Interactor

      # Finds sounds by query
      #
      # @params
      #   query [String] (Optional)
      #   offset [Integer] (Optional)
      #
      # @return
      #   sounds [Array<Sound>]
      #

      def call
        if context.query.to_s.length > 0
          context.sounds = Sound.fetch_by_query(context.query, offset: context.offset)
        else
          context.sounds = Sound.fetch_trending(offset: context.offset)
        end
      end
    end
  end
end
