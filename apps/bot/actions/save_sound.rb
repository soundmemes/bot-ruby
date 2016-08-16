module Apps; module Bot
  module Actions
    class SaveSound
      include Shared
      include EasyCallable

      def call
        result = Organaizers::SaveSound.call(params)

        if result.success?
          Botan.track(params[:telegram_user].id, { sound: result.sound.title }, "sound_#{ 'un' unless result.saved }saved")

          Responders::Inline::SaveSound.new(
            callback_query_id: params[:message].id,
            saved: result.saved,
            title: result.sound.title,
          ).respond!

        elsif result.error == :sound_not_found
          $logger.warn("Tried to save a sound with file_id #{ params[:file_id] } - wasn't found")
        else
          raise 'Unhandled result failure!'
        end
      end
    end
  end
end; end
