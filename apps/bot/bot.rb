require 'telegram/bot'
require 'singleton'
require_relative 'setup'

module Apps
  module Bot
    class Bot
      include Singleton

      SLEEP_BEFORE_RESTART = 5

      attr_reader :bot

      def initialize
        @bot = Telegram::Bot::Client.new(ENV['BOT_API_TOKEN'], logger: $logger)
      end

      def run
        @bot.listen do |message|
          begin
            params = {
              message: message,
              telegram_user: message.from,
            }

            case message
            when Telegram::Bot::Types::Message
              Handlers::Message.call(params)

            when Telegram::Bot::Types::CallbackQuery
              Handlers::CallbackQuery.call(params)

            when Telegram::Bot::Types::InlineQuery
              Handlers::InlineQuery.call(params)

            when Telegram::Bot::Types::ChosenInlineResult
              Handlers::ChosenInlineResult.call(params)

            else
              # Ignore unhandled message type
            end

          rescue Exception => e
            # If 'user blocked' error, update the user's status
            #
            if e.class == Telegram::Bot::Exceptions::ResponseError && e.error_code == 403
              # Organaizers::ChangeStatus.call({ telegram_user: message&.from, status: :blocked })
            else
              # Rescuing ALL the unhandled errors ONLY in production,
              # in other environments raise
              #
              case ENV['RACK_ENV']
              when 'production'
                $logger.error("#{ e.message } at #{ e.backtrace.join("\n") }")
              else
                raise e
              end
            end
          end
        end
      rescue Telegram::Bot::Exceptions::ResponseError => e
        case e.error_code

        # If 5** error, restart the bot in 5 seconds
        #
        when 500..599
          sleep SLEEP_BEFORE_RESTART
          run

        # Usually 409 means that someone else is long polling
        when 409
          $logger.warn("Terminated.")

        else
          raise e
        end
      end
    end
  end
end
