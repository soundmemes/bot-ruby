module Apps; module Bot
  module Utils
    class UserState
      STATE_IDLE             = :idle
      STATE_ADDING_NEW_SOUND = :invest_menu

      def initialize(user)
        @user = user
      end

      def set(state, params = nil)
        $redis.set("telegram_user:#{ @user.id }:current_state", state => params)
      end

      def get
        $redis.get("telegram_user:#{ @user.id }:current_state")&.keys&.[](0) || STATE_IDLE
      end

      def get_params
        $redis.get("telegram_user:#{ @user.id }:current_state")&.values&.[](0)
      end

      alias_method :params, :get_params
    end
  end
end
end
