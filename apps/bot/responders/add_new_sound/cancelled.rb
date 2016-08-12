module Apps; module Bot
  module Responders
    module AddNewSound
      class Cancelled
        include Shared

        def initialize(user: nil)
          @user = user
        end

        def respond!
          bot.api.send_message(
            chat_id: @user.id,
            text: "Sound adding was cancelled.",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::MainMenu.new.markup,
          )
        end
      end
    end
  end
end; end
