module Apps; module Bot
  module Responders
    module AddNewSound
      class SetContent
        def initialize(user: nil)
          @user = user
        end

        def respond!
          bot.api.send_message(
            chat_id: @user.id,
            text: "Good, now, please, send me a voice message or an *.ogg* file:",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::Empty.new.markup,
          )
        end
      end
    end
  end
end; end
