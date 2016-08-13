module Apps; module Bot
  module Errors
    module AddNewSound
      class ConversionError
        include Shared

        def initialize(user)
          @user = user
        end

        def send!
          bot.api.send_message(
            chat_id: @user.id,
            text: "Couldn't convert the file. Don't know why. Please, share the file you tried to send to me to @soundmemes chat, and my creators will help you.",
          )
        end
      end
    end
  end
end; end
