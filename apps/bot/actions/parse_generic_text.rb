module Apps; module Bot
  module Actions
    class ParseGenericText
      include Shared
      include EasyCallable
      include EasyState

      def call
        case user_state.get
        when Utils::UserState::STATE_ADDING_NEW_SOUND
          case user_state.params[:phaze].to_sym
          when :title
            params.merge!(title: params[:message].text.strip)
            Actions::AddNewSound::Parse.call(params)
          when :content
            Errors::AddNewSound::InvalidMimeType.new(params[:telegram_user]).send!
          when :tags
            params.merge!(tags: params[:message].text.strip)
            Actions::AddNewSound::Parse.call(params)
          end
        else # When a completely unknown command
          Botan.track(params[:telegram_user].id, { text: params[:message].text }, 'unknown_command')
          Errors::DoNotUnderstand.new(params[:telegram_user]).send!
        end
      end
    end
  end
end; end
