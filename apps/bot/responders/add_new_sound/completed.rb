module Apps; module Bot
  module Responders
    module AddNewSound
      class Completed
        include Shared

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
          bot.api.send_message(
            chat_id: options[:user].id,
            text: "Success! ✨ The sound will now appear in inline search results. You may share it directly with your friends.\n\n*Reminder:* To use the inline mode, just type `@#{ ENV['BOT_USERNAME'] } #{ @options[:title] }` or `@#{ ENV['BOT_USERNAME'] } SOME TAG` in *any* chat!",
            parse_mode: 'Markdown',
            reply_markup: Keyboards::MainMenu.new.markup,
          )

          input = options[:send_file] ? Faraday::UploadIO.new(options[:file].path, options[:mime_type]) : options[:file_id]

          response = bot.api.send_voice(
            chat_id: options[:user].id,
            voice: input,
            reply_markup: Keyboards::BeneathNewSound.new(query: options[:title]).markup,
          )

          response['result']&.[]('voice')&.[]('file_id')
        end

        private

        def options
          @options
        end
      end
    end
  end
end; end
