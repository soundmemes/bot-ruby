module Apps; module Bot
  module Utils
    class UserState
      STATE_IDLE             = :idle
      STATE_ADDING_NEW_SOUND = :adding_new_sound

      def initialize(user)
        @user = user
      end

      def set(state)
        $redis.set(key_state, state)
      end

      def get
        $redis.get(key_state)&.to_sym || STATE_IDLE
      end

      def set_params(params)
        $redis.mapped_hmset(key_state_params, params)
      end

      def get_params
        symbolize_keys($redis.hgetall(key_state_params) || {})
      end

      alias_method :params, :get_params

      def merge_params_with(hash = {})
        set_params(get_params.merge(hash))
      end

      def reset
        set(STATE_IDLE)
        $redis.del(key_state_params)
      end

      private

      def symbolize_keys(hash)
        hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
      end

      def key_state
        "telegram_user:#{ @user.id }:state"
      end

      def key_state_params
        "telegram_user:#{ @user.id }:state_params"
      end
    end
  end
end
end
