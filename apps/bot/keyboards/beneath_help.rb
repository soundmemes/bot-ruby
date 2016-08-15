module Apps; module Bot
  module Keyboards
    class BeneathHelp
      attr_reader :markup

      RATE_URL = 'https://telegram.me/storebot?start=soundmemesbot'.freeze
      GROUP_URL = 'https://telegram.me/soundmemeschat'.freeze
      CHANNEL_URL = 'https://telegram.me/soundmemes'.freeze

      def initialize(user: nil, query: nil)
        keyboard = [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Rate ⭐️⭐️⭐️⭐️⭐️',
            url: user ? Botan.shorten_url(user.id, RATE_URL) : RATE_URL,
          ),
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Join group',
              url: user ? Botan.shorten_url(user.id, GROUP_URL) : GROUP_URL,
            ),
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Join channel',
              url: user ? Botan.shorten_url(user.id, CHANNEL_URL) : CHANNEL_URL,
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
