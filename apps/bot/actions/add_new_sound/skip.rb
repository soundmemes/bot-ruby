module Apps; module Bot
  module Actions
    module AddNewSound
      class Skip
        include Shared
        include EasyCallable
        include EasyState

        def call
          if PHAZES[user_state.params[:phaze].to_sym][:skippable]
            next_phaze_index = AddNewSound.get_next_phaze_index(user_state.params[:phaze].to_sym)
            if next_phaze_index == COMPLETED
              Complete.call(params)
            else
              next_phaze = PHAZES.keys[next_phaze_index]
              user_state.merge_params_with(phaze: next_phaze)
              Responders::AddNewSound::Prepare.new(user: params[:telegram_user], phaze: next_phaze).respond!
            end
          else
            Errors::AddNewSound::CannotSkip.new(params[:telegram_user]).send!
          end
        end
      end
    end
  end
end; end
