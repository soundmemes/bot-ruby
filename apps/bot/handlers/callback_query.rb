module Apps; module Bot
  module Handlers
    class CallbackQuery
      include Shared
      include EasyCallable

      DATA_SAVE_SOUND = 'save_sound'

      def call
        case params[:message].data
        when /save_sound:(\d+)/
          params.merge!({
            sound_id: $1.to_i,
          })

          Actions::SaveSound.call(params)
        else
          # Unknown callback data, ignore
        end
      end
    end
  end
end; end
