module Apps; module Bot
  module Responders
    module AddNewSound
      class Completed
        include Shared
        include EasyState

        # Called when a new sound is successfully added
        #
        # @param [Hash] opts
        # @option opts [Object]  :user              Telegram user to send messages to
        # @option opts [String]  :file_id (nil)     Voice file_id
        # @option opts [File]    :file (nil)        Voice file. Ignored unless :send_file is true
        # @option opts [String]  :mime_type         Mime type of a file
        # @option opts [Boolean] :send_file (false) Whether to send a file instead of file_id
        # @option opts [String]  :title             Voice's title
        #
        def initialize(opts = {})
          @options = opts
        end

        def respond!
          input = options[:send_file] ? Faraday::UploadIO.new(options[:file].path, options[:mime_type]) : options[:file_id]

          response = bot.api.send_voice(
            chat_id: options[:user].id,
            voice: input,
            reply_markup: Keyboards::BeneathNewSound.new(query: options[:title]).markup,
          )

          bot.api.send_message(
            chat_id: options[:user].id,
            text: "Success! ✨ The sound will now appear in inline search results (find it by starting typing its title).\n\n*Reminder:* To use the inline mode, just type `@#{ ENV['BOT_USERNAME'] }` in *any* chat!",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::MainMenu.new.markup,
          )

          bot.api.send_message(
            chat_id: options[:user].id,
            text: "❤️ *me?* So give me a 5 stars feedback here: https://telegram.me/storebot?start=soundmemesbot\n💔 *me?* Tell why in @soundmemes chat 🤔",
            disable_web_page_preview: true,
            parse_mode: 'Markdown',
            reply_markup: Keyboards::MainMenu.new.markup,
          )

          response
        end

        private

        def options
          @options
        end
      end
    end
  end
end; end
