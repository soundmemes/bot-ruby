module Apps; module Bot
  module Actions
    module AddNewSound
      class Cancel
        include Shared
        include EasyCallable
        include EasyState

        def call
          user_state.reset
          Responders::AddNewSound::Cancelled.new(user: params[:telegram_user]).respond!
        end
      end
    end
  end
end; end
