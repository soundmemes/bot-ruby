module Apps; module Bot
  module Errors
    module AddNewSound
      class CannotSkip
        include Shared

        def initialize(user)
          @user = user
        end

        def send!
          bot.api.send_message(
            chat_id: @user.id,
            text: "Sorry, but you cannot skip this step. You may want to type /cancel to abort the process of adding a new sound.",
          )
        end
      end
    end
  end
end; end
