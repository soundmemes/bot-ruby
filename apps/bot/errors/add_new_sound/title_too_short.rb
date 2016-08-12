module Apps; module Bot
  module Errors
    module AddNewSound
      class TitleTooShort
        include Shared

        def initialize(user, min_length: nil)
          @user = user
          @min_length = min_length
        end

        def send!
          bot.api.send_message(
            chat_id: @user.id,
            text: "That title is too short. Minimum length is #{ @min_length }. Try again or type /cancel to abort.",
          )
        end
      end
    end
  end
end; end
