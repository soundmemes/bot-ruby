module Apps; module Bot
  module Handlers
    class InlineQuery
      include Shared
      include EasyCallable

      def call
        params[:query] = params[:message].query.to_s.strip
        params[:offset] = params[:message].offset&.to_i

        result = Organaizers::FetchSoundsByQuery.call(params)
        if result.success?
          Responders::InlineSoundResults.new(query_id: params[:message].id, results: result.sounds, trending: params[:query].length == 0).respond!
        else
          raise Exception.new('Unhandled result failure!')
        end
      end
    end
  end
end; end
