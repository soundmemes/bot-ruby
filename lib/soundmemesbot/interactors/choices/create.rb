require 'interactor'

module Interactors
  module Choices
    class Create
      include Interactor

      # Creates a new Choice
      #
      # @params
      #   user [User]
      #   sound [Sound]
      #   query [String] (Optional)
      #
      # @return
      #   choice [User]
      #

      def call
        context.choice = Choice.create(
          user: context.user,
          sound: context.sound,
          query: context.query,
        )
      end
    end
  end
end
