module Apps; module Bot
  module Keyboards
    class BeneathNewSound
      attr_reader :markup

      def initialize(query: nil, sound_id: nil)
        keyboard = [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: '⭐️ Add to fav',
              callback_data: "save_sound:#{ sound_id }",
            ),
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: 'Share',
              switch_inline_query: query
            ),
          ],
        ]

        @markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: keyboard,
          resize_keyboard: true,
        )
      end
    end
  end
end; end
