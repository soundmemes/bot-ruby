module Apps; module Bot
  module Responders
    module AddNewSound
      class SetTitle
        def initialize(user: nil)
          @user = user
        end

        def respond!
          bot.api.send_message(
            chat_id: @user.id,
            text: "First of all, enter a name of a new sound:",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::Empty.new.markup,
          )
        end
      end
    end
  end
end; end
