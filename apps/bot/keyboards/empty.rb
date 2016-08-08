

module Apps; module Bot
  module Keyboards
    class Empty
      attr_reader :markup

      def initialize
        @markup = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
      end
    end
  end
end; end
