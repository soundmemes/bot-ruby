module Apps; module Bot
  module Actions
    class Start
      include Shared
      include EasyCallable
      include EasyState

      def call
        user_state.reset
        result = Interactors::Users::FindOrCreate.call(params)
        Responders::Start.new(user: params[:telegram_user], is_new: result.is_new_user).respond!
      end
    end
  end
end; end
