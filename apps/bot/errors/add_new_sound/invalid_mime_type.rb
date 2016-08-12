module Apps; module Bot
  module Errors
    module AddNewSound
      class InvalidMimeType
        include Shared

        def initialize(user)
          @user = user
        end

        def send!
          bot.api.send_message(
            chat_id: @user.id,
            text: "This file is invalid. The only supported formats are .ogg, .mp3 or .wav. You can also send a direct voice message to me! Kindly, try again or type /cancel to abort.",
          )
        end
      end
    end
  end
end; end
