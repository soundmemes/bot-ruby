module Apps; module Bot
  module Errors
    class AdminOnly
      include Shared

      def initialize(user: nil)
        @user = user
      end

      def send!
        bot.api.send_message(
          chat_id: @user.id,
          text: "Sorry, that function is currently admin-only.",
        )
      end
    end
  end
end; end
