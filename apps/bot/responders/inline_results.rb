module Apps; module Bot
  module Responders
    class InlineSoundResults
      include Shared

      PARAMETER_ADD_NEW = 'add_from_inline'.freeze

      def initialize(query_id: nil, results: [])
        @query_id = query_id || (raise ArgumentError.new('query_id is nil!'))
        @results = results.first(49).map do |sound|
          title = sound.title
          # title += " | #{ sound.tags.map{ |tag| "##{ tag.content }" }.join(' ') }" if sound.tags.count > 0

          Telegram::Bot::Types::InlineQueryResultCachedVoice.new(
            type: 'voice',
            id: sound.id,
            voice_file_id: sound.file_id,
            title: title,
          )
        end
      end

      def respond!
        options = {
          inline_query_id: @query_id,
          results: @results,
          cache_time: 0,
        }

        options.merge!({
          switch_pm_text: 'Nothing found. Tap to add your own sound.',
          switch_pm_parameter: PARAMETER_ADD_NEW,
        }) unless @results.count > 0

        bot.api.answer_inline_query(options)
      end
    end
  end
end; end
