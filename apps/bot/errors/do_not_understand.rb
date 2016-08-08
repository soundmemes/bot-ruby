module Apps; module Bot
  module Errors
    class DoNotUnderstand
      include Shared

      def initialize(telegram_user)
        @user = telegram_user
      end

      def send!
        bot.api.send_message(
          chat_id: @user.id,
          text: "Sorry, #{ @user.first_name }, I don't understand you. Kindly, type /help to view available commands.",
        )
      end
    end
  end
end; end
