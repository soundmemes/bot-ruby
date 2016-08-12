module Apps; module Bot
  module Actions
    module AddNewSound
      class Prepare
        include Shared
        include EasyCallable
        include EasyState

        def call
          case user_state.get
          when Utils::UserState::STATE_ADDING_NEW_SOUND
            # TODO
            # ignore
          else
            interactor_result = Interactors::Users::FindOrCreate.call(params)
            if interactor_result.user.admin? || !Settings::ONLY_ADMIN_ADD_SOUND
              next_phaze = PHAZES.keys[0]
              user_state.set(Utils::UserState::STATE_ADDING_NEW_SOUND)
              user_state.set_params(phaze: next_phaze)
              Responders::AddNewSound::Prepare.new(user: params[:telegram_user], phaze: next_phaze).respond!
            else
              Errors::AdminOnly.new(user: params[:telegram_user]).send!
            end
          end
        end
      end
    end
  end
end; end
