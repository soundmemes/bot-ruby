module Apps; module Bot
  module Errors
    class Oops
      include Shared

      def initialize(user: nil)
        @user = user
      end

      def send!
        bot.api.send_message(
          chat_id: @user.id,
          text: "Oops! Something's broken here ☠ That's not okay, contact @soundmemes for help! ☹️",
        )
      end
    end
  end
end; end
