module Apps; module Bot
  module Keyboards
    class BeneathNewSound
      attr_reader :markup

      def initialize(query: nil)
        keyboard = [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: 'Share',
            switch_inline_query: query
          ),
        ]

        @markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: keyboard,
          resize_keyboard: true,
        )
      end
    end
  end
end; end
