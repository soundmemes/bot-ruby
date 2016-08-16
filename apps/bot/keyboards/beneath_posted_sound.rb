module Apps; module Bot
  module Keyboards
    class BeneathPostedSound
      attr_reader :markup

      def initialize(sound_id: nil)
        keyboard = [
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: '💾 Save sound',
            callback_data: "save_sound:#{ sound_id }",
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
