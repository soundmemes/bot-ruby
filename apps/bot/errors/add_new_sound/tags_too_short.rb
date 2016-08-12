module Apps; module Bot
  module Errors
    module AddNewSound
      class TagsTooShort
        include Shared

        def initialize(user)
          @user = user
        end

        def send!
          bot.api.send_message(
            chat_id: @user.id,
            text: "Tags cannot be empty. Try again or type /skip to skip this step or /cancel to abort.",
          )
        end
      end
    end
  end
end; end
