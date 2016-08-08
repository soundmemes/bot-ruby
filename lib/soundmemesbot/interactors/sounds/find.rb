require 'interactor'

module Interactors
  module Sounds
    class Find
      include Interactor

      # Finds a Sound by ID
      #
      # @params
      #   sound_id [Integer]
      #
      # @return
      #   sound [Sound]
      #

      def call
        context.sound = Sound[context.sound_id]
        raise SoundNotFoundError unless context.sound

      rescue SoundNotFoundError
        context.fail!(error: :sound_not_found)

      end

      class SoundNotFoundError < StandardError; end
    end
  end
end
