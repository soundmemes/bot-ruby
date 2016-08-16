require 'interactor'

module Interactors
  module Sounds
    class Save
      include Interactor

      # Saves a +sound+ to a +user+'s 'saved_sounds'
      #
      # @params
      #   sound [Sound]
      #   user [User]
      #
      # @return
      #   saved [Boolean] Whether the sound was added or removed
      #

      def call
        context.saved = if context.user.saved_sounds.include?(context.sound)
          context.user.remove_saved_sound(context.sound)
          false
        else
          context.user.add_saved_sound(context.sound)
          true
        end

        context.user.save_changes
      end
    end
  end
end
