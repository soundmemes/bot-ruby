require 'telegram/bot'
require 'singleton'
require_relative 'setup'
require_relative '../../lib/botan'

class Telegram::Bot::Client
  def fetch_updates
    response = api.getUpdates(offset: offset, timeout: timeout)
    return unless response['ok']

    response['result'].each do |data|
      update = Telegram::Bot::Types::Update.new(data)
      @offset = update.update_id.next
      message = extract_message(update)
      return unless message
      log_incoming_message(message)
      yield message
    end
  rescue Faraday::Error::TimeoutError
    retry
  end
end

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
        @bot.api.set_webhook
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
          retry

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
