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
            title = params[:title].to_s
              .gsub(Regexp.union(Settings::RESTRICTED_TITLE_SYMBOLS), '')
              .gsub(/\s+/, ' ')
              .strip
            if title.length >= MIN_TITLE_LENGTH
              user_state.merge_params_with(title: title)
            else
              return Errors::AddNewSound::TitleTooShort.new(params[:telegram_user], min_length: MIN_TITLE_LENGTH).send!
            end

          when :content
            if params[:content]
              if params[:content][:mime_type].match(%r{audio/.*}) || params[:content][:mime_type].match(%r{.*/ogg})
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
            tags = params[:tags].to_s
              .gsub(Regexp.union(Settings::RESTRICTED_TAG_SYMBOLS), '')
              .gsub(/\s+/, ' ')
              .strip
            if tags.length > 0
              user_state.merge_params_with(tags: tags)
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
