module Apps; module Bot
  module Handlers
    class Message
      include Shared
      include EasyCallable
      include EasyState

      def call
        continue = true

        %i(voice audio document).each do |type|
          if params[:message].send(type)
            if user_state.get == Utils::UserState::STATE_ADDING_NEW_SOUND
              params.merge!(
                content: {
                  mime_type: params[:message].send(type).mime_type,
                  file_id: params[:message].send(type).file_id,
                }
              )
              Actions::AddNewSound::Parse.call(params)
            else
              # User is not adding a new sound
            end

            continue = false
          end
        end

        return unless continue

        case params[:message].text
        when /^\/start(?:\s(\w+))?$/
          parameter = $1.to_s

          case parameter
          when Responders::InlineSoundResults::PARAMETER_ADD_NEW
            Botan.track(params[:telegram_user].id, { from: 'inline' }, 'start')
            Botan.track(params[:telegram_user].id, { from: 'inline' }, 'add_new_sound')
            prepare_for_new_sound

          else # When just a /start or with unknown parameter
            Botan.track(params[:telegram_user].id, { from: '/start' }, 'start')
            Actions::Start.call(params)
          end

        when '/help'
          Botan.track(params[:telegram_user].id, {}, 'help_request')
          Responders::Help.new(user: params[:telegram_user]).respond!

        when Keyboards::MainMenu::BUTTON_ADD_NEW, 'Add a new sound'
          Botan.track(params[:telegram_user].id, { from: 'button' }, 'add_new_sound')
          prepare_for_new_sound

        when '/new'
          Botan.track(params[:telegram_user].id, { from: '/new' }, 'add_new_sound')
          prepare_for_new_sound

        when '/skip'
          if user_state.get == Utils::UserState::STATE_ADDING_NEW_SOUND
            Actions::AddNewSound::Skip.call(params)
          else
            # 'Nothing to skip' message
          end

        when '/cancel', '/abort'
          if user_state.get == Utils::UserState::STATE_ADDING_NEW_SOUND
            Botan.track(params[:telegram_user].id, {}, 'sound_adding_cancelled')
            Actions::AddNewSound::Cancel.call(params)
          else
            # 'Nothing to cancel' message
          end

        else # When a generic message
          Actions::ParseGenericText.call(params)
        end
      end

      private

      def prepare_for_new_sound
        Actions::AddNewSound::Prepare.call(params)
      end
    end
  end
end; end
