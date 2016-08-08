module Apps; module Bot
  module Shared
    def bot
      Bot.instance.bot
    end
  end

  module EasyCallable
    def self.included(base)
      base.send :include, InstanceMethods
      base.extend ClassMethods
    end

    module InstanceMethods
      def initialize(params = {})
        @params = params
      end

      def params
        @params
      end
    end

    module ClassMethods
      def call(params = {})
        self.new(params).call
      end
    end
  end

  module EasyState
    def user_state
      @user_state ||= Utils::UserState.new(params[:telegram_user])
    end
  end
end; end
