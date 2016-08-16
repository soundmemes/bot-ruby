module Apps; module Bot
  module Responders
    module AddNewSound
      class Prepare
        include Shared

        def initialize(user: nil, phaze: nil)
          @user = user
          @phaze = phaze
        end

        def respond!
          text = case @phaze
          when :title
            "First of all, I need a *title* for a new sound. Please send me a good title like `Inception horn` - as clear as possible. You may add tags in a later step.\n\n⚠️ *Note:* Symbols *#{ Settings::RESTRICTED_TITLE_SYMBOLS.join(', ') }* will be ignored.\n💡 *Tip:* You can /cancel sound creation any time."
          when :content
            "Good, now, please, send me a *voice message* or an *audio file*. Please note, that the file will be cut to the first #{ Settings::MAX_SOUND_DURATION } seconds."
          when :tags
            "Finally, send some comma separated tags (including emojis and in any language), e.g. `😂, lol, funny`. These tags will be used when searching for your sound.\n\n⚠️ *Note:* Symbols *#{ Settings::RESTRICTED_TAG_SYMBOLS.join(', ') }* will be ignored.\n💡 *Tip:* You can /skip this step."
          end

          bot.api.send_message(
            chat_id: @user.id,
            text: text,
            parse_mode: 'Markdown',
            reply_markup: Keyboards::Empty.new.markup,
          )
        end
      end
    end
  end
end; end
