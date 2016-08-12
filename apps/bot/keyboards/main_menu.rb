module Apps; module Bot
  module Keyboards
    class MainMenu
      BUTTON_ADD_NEW = 'Add a new sound'

      attr_reader :markup

      def initialize
        keyboard = [
          BUTTON_ADD_NEW
        ]

        @markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: keyboard,
          resize_keyboard: true,
        )
      end
    end
  end
end; end
