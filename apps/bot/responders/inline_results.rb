module Apps; module Bot
  module Responders
    class InlineSoundResults
      include Shared

      PARAMETER_ADD_NEW = 'add_from_inline'.freeze

      def initialize(query_id: nil, query: nil, results: [], saved_sound_ids: [], offset: nil)
        @query_id = query_id
        @results = results.first(49).map do |sound| # TODO 49
          title = "#{ '⭐️ ' if saved_sound_ids.include?(sound.id) }#{ sound.title }"

          Telegram::Bot::Types::InlineQueryResultCachedVoice.new(
            type: 'voice',
            id: sound.id,
            voice_file_id: sound.file_id,
            title: title,
            reply_markup: Keyboards::BeneathPostedSound.new(sound_id: sound.id).markup,
          )
        end
        @offset = offset
        @query = query
      end

      def respond!
        options = {
          inline_query_id: @query_id,
          results: @results,
          next_offset: @offset,
          is_personal: true,
          cache_time: 5,
        }

        switch_pm_text, param = if @query.length > 0
          if @results.count > 0
            ["🔎 Results for \"#{ @query }\":", nil]
          else
            ['⚠️ Nothing found! Tap to add a new sound', PARAMETER_ADD_NEW]
          end
        else
          ['🔥 Popular sounds:', nil]
        end

        options.merge!({
          switch_pm_text: switch_pm_text,
          switch_pm_parameter: param,
        })

        bot.api.answer_inline_query(options)
      end
    end
  end
end; end
