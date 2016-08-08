module Apps; module Bot
  module Handlers
    class InlineQuery
      include Shared
      include EasyCallable

      def call
        params[:query] = params[:message].query.to_s.strip

        result = Organaizers::FetchSoundsByQuery.call(params)
        if result.success?
          Responders::InlineSoundResults.new(query_id: params[:message].id, results: result.sounds)
        else
          raise Exception.new('Unhandled result failure!')
        end
      end
    end
  end
end; end
