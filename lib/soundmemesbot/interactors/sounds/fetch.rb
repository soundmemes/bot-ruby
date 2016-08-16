require 'interactor'
require_relative '../../../utils/array_extensions'

module Interactors
  module Sounds
    class Fetch
      include Interactor
      using Utils::ArrayExtensions

      # Finds sounds by query
      #
      # @params
      #   user [User] (Optional)
      #   query [String] (Optional)
      #   offset [Integer] (Optional)
      #   limit [Integer] (Optional)
      #
      # @return
      #   sounds [Array<Sound>]
      #   saved_sound_ids [Array<Integer>] (Optional) A list of sound ids which are saved by current user
      #   next_offset [Integer] (Optional) If there are any more sounds left to fetch
      #

      def call
        sounds = if context.query.to_s.length > 0
          Sound.fetch_by_query(context.query)
        else
          Sound.fetch_trending
        end

        context.next_offset = context.offset.to_i + (context.limit || sounds.count)
        context.next_offset = nil if context.next_offset >= sounds.count

        if context.user
          # Move the saved sounds to the top of the list
          #
          sounds.reverse.select do |s|
            if context.user.saved_sounds.include?(s)
              (context.saved_sound_ids ||= []) << s.id
              next true
            end
          end.each{ |s| sounds.promote(s) }
        end

        context.sounds = sounds[context.offset.to_i, context.limit]
      end
    end
  end
end
