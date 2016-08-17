module Apps; module Bot
  module Responders
    module Inline
      class SaveSound
        include Shared

        TITLE_STRIP_AT = 20.freeze

        def initialize(callback_query_id: nil, saved: nil, title: nil)
          @callback_query_id = callback_query_id
          @saved = saved
          @title = title
        end

        def respond!
          text = if @saved
            "⭐️ \"#{ strip_title }\" added to favorites"
          else
            "🚫 \"#{ strip_title }\" removed from favorites"
          end

          begin
            bot.api.answer_callback_query({
              text: text,
              callback_query_id: @callback_query_id,
            })
          rescue Exception => e
            raise e if ENV['RACK_ENV'] == 'production'
          end
        end

        private

        def strip_title
          @title.length > TITLE_STRIP_AT ? "#{ @title[0, TITLE_STRIP_AT - 2] }.." : @title
        end
      end
    end
  end; end
end
