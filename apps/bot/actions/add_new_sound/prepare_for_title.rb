module Apps; module Bot
  module Actions
    module AddNewSound
      class PrepareForTitle
        def call
          Responders::AddNewSound::SetTitle.new(user: params[:telegram_user]).respond!
          user_state.set(Utils::UserState::STATE_ADDING_NEW_SOUND, phaze: :title)
        end
      end
    end
  end
end; end
