module Apps; module Bot
  module Actions
    module AddNewSound
      class PrepareForContent
        def call
          Responders::AddNewSound::SetContent.new(user: params[:telegram_user]).respond!
          user_state.params[:phaze] = :content
        end
      end
    end
  end
end; end
