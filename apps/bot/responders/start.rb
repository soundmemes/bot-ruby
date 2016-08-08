module Apps; module Bot
  module Responders
    class Start
      def initialize(user: nil, is_new: false)
        @user = user
        @is_new = is_new
      end

      def respond!
        bot.api.send_message(
          chat_id: @user.id,
          text: "Hello, #{ @user.first_name }!",
          parse_mode: 'Markdown',
          reply_markup: Keyboards::MainMenu.new.markup,
        )
      end
    end
  end
end; end
