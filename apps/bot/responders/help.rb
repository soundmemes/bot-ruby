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

*How to use (🇺🇸):*
I'm very easy to play with - just type \"`@#{ ENV['BOT_USERNAME'] } `\" (with space) in *any* chat and you'll see a list of *trending* sounds - they are mostly used in the last 24 hours.

Then, you can type something again - it may be a word or even an emoji 👍 - and I'll find matching sounds for you. Please note, that I'm searching sounds through *titles* and *tags*. The results will be ordered by overall usage count.

If you cannot find what you're looking for - tap an `Add new` button in inline mode, or use my keyboard or just type /new.

*Как использовать (🇷🇺):*
Чтобы начать пользоваться ботом, введите \"`@#{ ENV['BOT_USERNAME'] } `\" (с пробелом) в *любом* чате и вы увидите список *популярных звуков* - их использовали чаще всего в течение последних 24 часов.

Вы можете начать набирать слово или даже ввести эмодзи, и я найду подходящий звук (поиск происходит по *названию* и *тэгам*). Результаты будут отсортированы по общему количеству использований.

А если вы не можете найти нужный звук - нажмите на `Add new` или воспользуйтесь моей клавиатурой (кнопка внизу) или просто отправьте /new - и появится интерфейс добавления нового звука. Если что непонятно, пишите в @soundmemeschat.

*Community:*
If you have any more questions - welcome to my fans' group @soundmemeschat. If you want to stay updated with news and cool new sounds - check out my channel @soundmemes. Also you're welcome to give me 5 stars in `@storebot`:",
          parse_mode: 'Markdown',
          disable_web_page_preview: true,
          reply_markup: Keyboards::BeneathHelp.new.markup,
        )
      end
    end
  end
end; end
