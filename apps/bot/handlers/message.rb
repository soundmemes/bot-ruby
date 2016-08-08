module Apps; module Bot
  module Handlers
    class Message
      include Shared
      include EasyCallable
      include EasyState

      PARAMETER_ADD_NEW = 'add_new'.freeze

      def call
        interactor_result = Interactors::Users::FindOrCreate.call(params)

        %i(voice audio document).each do |type|
          if params[:message].send(type)
            if user_state.get == Utils::UserState::STATE_ADDING_NEW_SOUND
              if user_state.params[:phaze] == :content
                params.merge!(
                  mime_type: params[:message].send(type).mime_type,
                  file_id: params[:message].send(type).file_id,
                  title: ("#{ params[:message].audio.title }" if type == :audio),
                )
                Actions::AddNewSound::HandleContent.call(params)
              else
                # It's not a content phaze
              end
            else
              # User is not adding a new sound
            end

            return
          end
        end

        case params[:message].text
        when /^\/start(?:\s(\w+))?$/
          parameter = $1.to_s
          case parameter
          when PARAMETER_ADD_NEW
            Actions::AddNewSound::PrepareForTitle.call(params)

          else # When just a /start
            Responders::Start.new(user: params[:telegram_user], is_new: interactor_result.is_new_user).respond!
          end
        when Keyboards::MainMenu::BUTTON_ADD_NEW
          Actions::AddNewSound::PrepareForTitle.call(params)

        else # When a generic message
          case user_state.get
          when Utils::UserState::STATE_ADDING_NEW_SOUND
            case user_state.params[:phaze]
            when :title
              params.merge!(title: params[:message].text.strip)
              Actions::AddNewSound::HandleTitle.call(params)
              Actions::AddNewSound::PrepareForContent.call(params)
            when :content
              # A content must be a voice or a file, display a 'retry' error message
            when :tags
              # Handle tags
              # Finish adding a new sound
            end

          else # When a completely unknown command
            Errors::DoNotUnderstand.new(params[:telegram_user]).send!
          end
        end
      end
    end
  end
end; end
