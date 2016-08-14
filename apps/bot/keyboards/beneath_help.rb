module Apps; module Bot
  module Keyboards
    class BeneathHelp
      attr_reader :markup

      def initialize(query: nil)
        keyboard = [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Rate ⭐️⭐️⭐️⭐️⭐️',
            url: 'https://telegram.me/storebot?start=soundmemesbot',
          ),
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Join group',
              url: 'https://telegram.me/soundmemeschat',
            ),
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Join channel',
              url: 'https://telegram.me/soundmemes',
            ),
          ]
        ]

        @markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: keyboard,
          resize_keyboard: true,
        )
      end
    end
  end
end; end
