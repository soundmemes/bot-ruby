module Apps; module Bot
  module Responders
    class Help
      include Shared

      def initialize(user: nil)
        @user = user
      end

      def respond!
        bot.api.send_message(
          chat_id: @user.id,
          text: "*About me:*
Hi, my name is Sound Memes Bot, I was crafted to make Telegram chats more fun 🎉

I have a plenty of different sounds, which can be used as reactions to someone's messages, bad jokes etc.

*How to use:*
I'm very easy to play with - just type `@#{ ENV['BOT_USERNAME'] }` in *any* chat and you'll see a list of *trending* sounds - they are mostly used in the last 24 hours.

Then, you can type something again - it may be a word or even an emoji 👍 - and I'll find matching sounds for you. Please note, that I'm searching sounds through *titles* and *tags*. The results will be ordered by overall usage count.

If you cannot find what you're looking for - tap an `Add new` button in inline mode, or use my keyboard or just type /new.

*Feedback:*
That's it. If you have any more questions - welcome to my fans' group @soundmemes ✌ Also you're welcome to leave a feedback here: https://telegram.me/storebot?start=soundmemesbot (press `Start` when clicked).",
          parse_mode: 'Markdown',
          disable_web_page_preview: true,
          reply_markup: Keyboards::MainMenu.new.markup,
        )
      end
    end
  end
end; end
