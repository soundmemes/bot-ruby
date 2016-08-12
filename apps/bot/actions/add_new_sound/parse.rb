module Apps; module Bot
  module Actions
    module AddNewSound
      class Parse
        include Shared
        include EasyCallable
        include EasyState

        def call
          current_phaze = user_state.get_params[:phaze].to_sym

          case current_phaze
          when :title
            if params[:title].to_s.length >= MIN_TITLE_LENGTH
              user_state.merge_params_with(title: params[:title])
            else
              return Errors::AddNewSound::TitleTooShort.new(params[:telegram_user], min_length: MIN_TITLE_LENGTH).send!
            end

          when :content
            if params[:content]
              if PERMITTED_MIMES.include?(params[:content][:mime_type])
                user_state.merge_params_with(
                  file_id: params[:content][:file_id],
                  mime_type: params[:content][:mime_type])
              else
                return Errors::AddNewSound::InvalidMimeType.new(params[:telegram_user]).send!
              end
            else
              return Errors::AddNewSound::InvalidMimeType.new(params[:telegram_user]).send!
            end

          when :tags
            if params[:tags].to_s.length > 0
              user_state.merge_params_with(tags: params[:tags])
            else
              return Errors::AddNewSound::TagsTooShort.new(params[:telegram_user]).send!
            end

          else
            raise Exception.new("Unknown phaze #{ current_phaze }!")
          end

          next_phaze_index = AddNewSound.get_next_phaze_index(current_phaze)
          if next_phaze_index == COMPLETED
            Complete.call(params)
          else
            next_phaze = PHAZES.keys[next_phaze_index]
            user_state.merge_params_with(phaze: next_phaze)
            Responders::AddNewSound::Prepare.new(user: params[:telegram_user], phaze: next_phaze).respond!
          end
        end
      end
    end
  end
end; end
