module Apps; module Bot
  module Responders
    class InlineSoundResults
      include Shared

      PARAMETER_ADD_NEW = 'add_from_inline'.freeze

      def initialize(query_id: nil, results: [], trending: false, offset: nil)
        @query_id = query_id || (raise ArgumentError.new('query_id is nil!'))
        @offset = offset
        @results = results.first(49).map do |sound|
          title = sound.title
          usages = sound.choices.count
          title += " (#{ usages } usage#{ usages == 1 ? nil : 's' } #{ trending ? 'today' : 'total' })"
          title += " #{ sound.tags.map{ |tag| "##{ tag.content }" }.join(' ') }" if sound.tags.count > 0

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
          next_offset: @offset,
        }

        switch_pm_text = 'Tap here to add your own sound.'

        options.merge!({
          switch_pm_text: switch_pm_text,
          switch_pm_parameter: PARAMETER_ADD_NEW,
        })

        bot.api.answer_inline_query(options)
      end
    end
  end
end; end
