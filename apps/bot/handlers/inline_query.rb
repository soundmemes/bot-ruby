module Apps; module Bot
  module Handlers
    class InlineQuery
      include Shared
      include EasyCallable

      def call
        params.merge!({
          query: params[:message].query.to_s.strip,
          offset: params[:message].offset.to_i,
          limit: Settings::MAX_QUERY_RESULTS,
        })

        Botan.track(params[:telegram_user].id, { query: params[:query] }, 'inline_query') unless params[:offset] > 0

        result = Organaizers::FetchSoundsByQuery.call(params)
        if result.success?

          Responders::InlineSoundResults.new(
            query_id: params[:message].id,
            query: params[:query],
            results: result.sounds,
            saved_sound_ids: Array(result.saved_sound_ids),
            offset: result.next_offset,
          ).respond!

        else
          raise Exception.new('Unhandled result failure!')
        end
      end
    end
  end
end; end
