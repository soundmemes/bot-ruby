require 'interactor'

module Interactors
  module Users
    class FindOrCreate
      include Interactor

      # Finds a User by Telegram ID or optionally creates one if not found in DB
      #
      # @params
      #   telegram_user [Object] Must respond to .id method
      #
      # @return
      #   user [User]
      #   is_new_user [Boolean] Whether is user just created or not
      #

      def call
        context.user = User.find_by_telegram_id(context.telegram_user.id)
        return if context.user

        context.is_new_user = true
        context.user = User.create(
          telegram_id: context.telegram_user.id,
        )
      end
    end
  end
end
