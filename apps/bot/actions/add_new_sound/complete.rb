module Apps; module Bot
  module Actions
    module AddNewSound
      class Complete
        include Shared
        include EasyCallable
        include EasyState

        def call
          merged = user_state.get_params.select{ |k, v| %i(file_id mime_type file title tags).include?(k) }
          result = Organaizers::CreateSound.call(params.merge(merged))
          if result.success?
            user_state.reset

            new_file_id = Responders::AddNewSound::Completed.new(
              user:      params[:telegram_user],
              file_id:   result.file_id,
              mime_type: result.mime_type,
              file:      result.file,
              send_file: result.replace_file_id,
              title:     result.title,
              sound_id:  result.sound.id,
              tags:      result.sound.tags,
            ).respond!['result']&.[]('voice')&.[]('file_id')

            Botan.track(params[:telegram_user].id, { mime_type: result.mime_type }, 'sound_added')

            if result.replace_file_id
              raise "No file_id was returned!" unless new_file_id

              result.sound.file_id = new_file_id
              result.sound.save_changes
            end

            File.delete(result.file) if result.file
          elsif result.error == :invalid_mime_type
            $logger.error(":invalid_mime_type error!")
            Botan.track(params[:telegram_user].id, { error: { invalid_mime_type: result.mime_type } }, 'add_new_sound_error')

            user_state.reset
            Errors::AddNewSound::InvalidMimeType.new(params[:telegram_user]).send!
            Responders::BackToMenu.new(user: params[:telegram_user]).respond!

          elsif result.error == :conversion_error
            $logger.error(":conversion_error!")
            Botan.track(params[:telegram_user].id, { error: 'conversion_error' }, 'add_new_sound_error')

            user_state.reset
            Errors::AddNewSound::ConversionError.new(params[:telegram_user]).send!
            Responders::BackToMenu.new(user: params[:telegram_user]).respond!

          else
            raise Exception.new('Unhandled result failure!')

          end
        rescue Telegram::Bot::Exceptions::ResponseError => e
          $logger.warn("HANDLED: #{ e.message } at #{ e.backtrace.join("\n") }")
          Botan.track(params[:telegram_user].id, { error: 'unknown' }, 'add_new_sound_error')

          user_state.reset

          Errors::Oops.new(user: params[:telegram_user]).send!
          Responders::BackToMenu.new(user: params[:telegram_user]).respond!
        end
      end
    end
  end
end; end
