module Apps; module Bot
  module Responders
    class Start
      include Shared

      def initialize(user: nil, is_new: false)
        @user = user
        @is_new = is_new
      end

      def respond!
        bot.api.send_message(
          chat_id: @user.id,
          text: "Hello, #{ @user.first_name }, nice to meet you!\n\n*Tip:* Type /help to learn more about my capabilities 😊",
          parse_mode: 'Markdown',
          reply_markup: Keyboards::MainMenu.new.markup,
        )

        if @is_new
          sound = Sound[Settings::HELLO_SOUND_ID]

          bot.api.send_message(
            chat_id: @user.id,
            text: "This is my traditional *Hello world* message. Please, tap `Share` button below the sound to see how it works.",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::MainMenu.new.markup,
          )

          bot.api.send_voice(
            chat_id: @user.id,
            voice: sound.file_id,
            reply_markup: Keyboards::BeneathNewSound.new(query: sound.title).markup,
          )
        end
      end
    end
  end
end; end
