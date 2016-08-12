module Apps; module Bot
  module Handlers
    class ChosenInlineResult
      include Shared
      include EasyCallable

      def call
        params.merge!({
          sound_id: params[:message].result_id,
          query: params[:message].query
        })

        result = Organaizers::RecordSoundChoice.call(params)
        if result.failure?
          if result.error == :sound_not_found
            # How can that be? :/
            raise Exception.new('result_id is invalid! This is a bug!')
          else
            raise Exception.new('Unhandled result failure!')
          end
        end
      end
    end
  end
end; end
