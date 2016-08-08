module Apps; module Bot
  module Responders
    class InlineSoundResults
      def initialize(query_id: nil, results: [])
        @query_id = query_id || (raise ArgumentError.new('query_id is nil!'))
        @results = results.map do |sound|
          if sound.file_id
            Telegram::Bot::Types::InlineQueryResultCachedVoice.new(
              type: 'voice',
              id: sound.id,
              voice_file_id: sound.file_id,
              title: sound.title,)
          else
            Telegram::Bot::Types::InlineQueryResultVoice.new(
              type: 'voice',
              id: sound.id,
              voice_url: 'TODO',
              title: sound.title,)
          end
        end
      end

      def respond!
        options = {
          inline_query_id: @query_id,
          results: @results,
        }

        options.merge!({
          switch_pm_text: 'Nothing found. Tap to add your own sound.',
          switch_pm_parameter: 'add_from_inline',
        }) unless @results.count > 0

        bot.api.answer_inline_query(options)
      end
    end
  end
end; end
